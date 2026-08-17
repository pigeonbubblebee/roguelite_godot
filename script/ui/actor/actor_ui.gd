class_name ActorUI
extends Control

var actor: Actor

@export var _health_bar_path: NodePath
@onready var health_bar = get_node(_health_bar_path)
@export var _armor_bar_path: NodePath
@onready var armor_bar = get_node(_armor_bar_path)
@export var _target_path: NodePath
@onready var target = get_node(_target_path)
@export var _number_preview_path: NodePath
@onready var number_preview = get_node(_number_preview_path)

@export var _status_icon_container_path: NodePath
@onready var status_icon_container = get_node(_status_icon_container_path)

@export var damage_number_scene: PackedScene

@onready var status_icon_helper : ActorUIStatusIconHelper = ActorUIStatusIconHelper.new()

var _status_icons : Dictionary = {}

signal hover_started(actorUI)
signal hover_ended(actorUI)

signal status_icon_hover_started(actorUI, status_effect)
signal status_icon_hover_ended(actorUI, status_effect)

# Floating number queue
var _damage_number_queue: Array[Dictionary] = []
var _processing_damage_numbers := false

# How long to wait before showing the next number.
@export var damage_number_delay := 0.15

func _process(delta: float) -> void:
	if actor:
		if actor.get_actor_name() == "Player":
			for status in (actor.get_status_manager().get_active_status()):
				#print(status.get_name())
				#print(status.get_reference_count())
				pass

func _ready():
	if actor:
		actor.connect("health_updated", Callable(self, "update_health_bar"))
		actor.connect("armor_updated", Callable(self, "update_armor_bar"))
		actor.damage_taken.connect(_on_damage_taken)
		actor.armor_gained.connect(_on_armor_gain)
		actor.get_status_manager().status_added.connect(_on_status_added)
		actor.health_healed.connect(_on_health_healed)
		
		actor.get_status_manager().status_updated.connect(_on_status_update)
		_on_status_update(actor.get_status_manager().get_active_status())
		
		update_armor_bar(actor._armor)
		update_health_bar()
	
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(target, "modulate:a", 0.3, 0.6)
	tween.tween_property(target, "modulate:a", 1.0, 0.6)
	
	var tween2 = create_tween()
	tween2.set_loops()

	tween2.tween_property(number_preview, "modulate:a", 0.3, 0.6)
	tween2.tween_property(number_preview, "modulate:a", 1.0, 0.6)
	
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func set_target_visibility(visible: bool, texture: Texture2D = null):
	target.visible = visible
	target.texture = texture
	
func set_number_preview_visibility(visible: bool, value : String = ""):
	number_preview.visible = visible
	number_preview.text = value
	
func update_health_bar():
	health_bar.value = float(actor._health) / actor.actor_data.max_health * 100
	
func update_armor_bar(armor: int):
	armor_bar.value = float(armor) / actor.actor_data.max_health * 100

func _on_status_update(status_effects : Array[StatusEffect]):
	var active_status_set := {}

	for status in status_effects:
		if not status.get_is_visible():
			continue
		
		active_status_set[status] = true

		var icon : StatusEffectIcon

		if not _status_icons.has(status):
			icon = status_icon_helper.status_icon_scene.instantiate()
			status_icon_container.add_child(icon)

			icon.status_effect = status

			icon.hover_started.connect(_on_status_icon_mouse_entered)
			icon.hover_ended.connect(_on_status_icon_mouse_exited)

			_status_icons[status] = icon
		else:
			icon = _status_icons[status]

		var stacks = status.get_stacks()
		var icon_type = status.get_icon_type()
		var type = status.status_type

		if status_icon_helper.status_texture_map.has(icon_type):
			icon.icon.texture = status_icon_helper.status_texture_map[icon_type]

		icon.stacks_label.text = str(stacks)

		var text_color = C_ColorPalette.CYAN if type == "Buff" else C_ColorPalette.RED
		icon.stacks_label.add_theme_color_override("font_color", text_color)

	for status in _status_icons.keys():
		if not active_status_set.has(status):
			var icon = _status_icons[status]
			icon.queue_free()
			_status_icons.erase(status)

func _mouse_entered():
	#print(actor.get_team_position())
	hover_started.emit(self)

func _mouse_exited():
	hover_ended.emit(self)
	
func _on_status_icon_mouse_entered(status):
	status_icon_hover_started.emit(self, status)
	
func _on_status_icon_mouse_exited(status):
	status_icon_hover_ended.emit(self, status)
	
	
# DMG NUMBER Q

func _queue_damage_number(type: String, value = null, context = null):
	if not damage_number_scene:
		return
	
	_damage_number_queue.append({
		"type": type,
		"value": value,
		"context": context
	})
	
	if not _processing_damage_numbers:
		_process_damage_number_queue()

func _process_damage_number_queue() -> void:
	if _damage_number_queue.is_empty():
		_processing_damage_numbers = false
		return
	
	_processing_damage_numbers = true
	
	var entry: Dictionary = _damage_number_queue.pop_front()
	_spawn_damage_number(entry)
	
	await get_tree().create_timer(damage_number_delay).timeout
	
	_process_damage_number_queue()

func _spawn_damage_number(entry: Dictionary) -> void:
	var damage_number_instance = damage_number_scene.instantiate()
	
	match entry["type"]:
		"damage":
			damage_number_instance.bind(
				entry["value"],
				entry["context"]
			)
			
		"armor":
			damage_number_instance.bind_armor(
				entry["value"]
			)
			
		"heal":
			damage_number_instance.bind_healing(
				entry["value"]
			)
			
		"status":
			damage_number_instance.bind_status(
				entry["value"]
			)
	
	damage_number_instance.global_position = _get_damage_number_position()
	
	get_tree().current_scene.call_deferred(
		"add_child",
		damage_number_instance
	)

func _get_damage_number_position() -> Vector2:
	return global_position + Vector2(
		size.x / 2.0 - 5.0,
		size.y / 2.0 - 20.0
	)

func _on_damage_taken(amt, ctx):
	_queue_damage_number("damage", amt, ctx)

func _on_armor_gain(amt):
	_queue_damage_number("armor", amt)

func _on_health_healed(amt):
	_queue_damage_number("heal", amt)

func _on_status_added(status: StatusEffect):
	if not status.get_is_visible():
		return
	
	_queue_damage_number("status", status)
