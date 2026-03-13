class_name ActorUI
extends Control

var actor: Actor

@export var _health_bar_path: NodePath
@onready var health_bar = get_node(_health_bar_path)
@export var _armor_bar_path: NodePath
@onready var armor_bar = get_node(_armor_bar_path)
@export var _target_path: NodePath
@onready var target = get_node(_target_path)

@export var _status_icon_container_path: NodePath
@onready var status_icon_container = get_node(_status_icon_container_path)

@export var damage_number_scene: PackedScene

@onready var status_icon_helper : ActorUIStatusIconHelper = ActorUIStatusIconHelper.new()

signal hover_started(actorUI)
signal hover_ended(actorUI)

signal status_icon_hover_started(actorUI, status_effect)
signal status_icon_hover_ended(actorUI, status_effect)

func _ready():
	if actor:
		actor.connect("health_updated", Callable(self, "update_health_bar"))
		actor.connect("armor_updated", Callable(self, "update_armor_bar"))
		actor.damage_taken.connect(_on_damage_taken)
		actor.armor_gained.connect(_on_armor_gain)
		
		actor.get_status_manager().status_updated.connect(_on_status_update)
		
		update_armor_bar(actor._armor)
		update_health_bar()
	
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(target, "modulate:a", 0.3, 0.6)
	tween.tween_property(target, "modulate:a", 1.0, 0.6)
	
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func set_target_visibility(visible: bool, texture: Texture2D = null):
	target.visible = visible
	target.texture = texture
	
func update_health_bar():
	health_bar.value = float(actor._health) / actor.actor_data.max_health * 100
	
func update_armor_bar(armor: int):
	armor_bar.value = float(armor) / actor.actor_data.max_health * 100
	
func _on_armor_gain(amt):
	if not damage_number_scene:
		return
	
	var damage_number_instance = damage_number_scene.instantiate()
	damage_number_instance.bind_armor(amt)
	damage_number_instance.global_position = global_position + Vector2(size.x / 2 - 5, size.y / 2 - 20)
	get_tree().current_scene.call_deferred("add_child", damage_number_instance)

func _on_damage_taken(amt, ctx):
	if not damage_number_scene:
		return
	
	var damage_number_instance = damage_number_scene.instantiate()
	damage_number_instance.bind(amt, ctx)
	damage_number_instance.global_position = global_position + Vector2(size.x / 2 - 5, size.y / 2 - 20)
	get_tree().current_scene.call_deferred("add_child", damage_number_instance)

func _on_status_update(status_effects : Array[StatusEffect]):
	for child in status_icon_container.get_children():
		child.queue_free()

	for status in status_effects:
		var icon_instance : StatusEffectIcon = status_icon_helper.status_icon_scene.instantiate()
		status_icon_container.add_child(icon_instance)

		var status_id = status.get_status_id()
		var stacks = status.get_stacks()
		var icon_type = status.get_icon_type()
		var type = status.status_type

		if status_icon_helper.status_texture_map.has(icon_type):
			icon_instance.icon.texture = status_icon_helper.status_texture_map[icon_type]
		
		icon_instance.stacks_label.text = str(stacks)
		var text_color = ColorPalette.CYAN if type == "Buff" else ColorPalette.RED
		icon_instance.stacks_label.add_theme_color_override("font_color", text_color)
		
		icon_instance.status_effect = status
		
		icon_instance.hover_started.connect(_on_status_icon_mouse_entered)
		icon_instance.hover_ended.connect(_on_status_icon_mouse_exited)

func _mouse_entered():
	#print(actor.get_team_position())
	hover_started.emit(self)

func _mouse_exited():
	hover_ended.emit(self)
	
func _on_status_icon_mouse_entered(status):
	status_icon_hover_started.emit(self, status)
	
func _on_status_icon_mouse_exited(status):
	status_icon_hover_ended.emit(self, status)
