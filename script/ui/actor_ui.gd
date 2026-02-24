class_name ActorUI
extends Control

var actor: Actor

@export var _health_bar_path: NodePath
@onready var health_bar = get_node(_health_bar_path)
@export var _target_path: NodePath
@onready var target = get_node(_target_path)

@export var damage_number_scene: PackedScene

func _ready():
	if actor:
		actor.connect("health_updated", Callable(self, "update_health_bar"))
		actor.damage_taken.connect(_on_damage_taken)
	
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(target, "modulate:a", 0.3, 0.6)
	tween.tween_property(target, "modulate:a", 1.0, 0.6)
	
func set_target_visibility(visible: bool, texture: Texture2D = null):
	target.visible = visible
	target.texture = texture
	
func update_health_bar():
	health_bar.value = float(actor._health) / actor.actor_data.max_health * 100
	# print(actor.actor_data.max_health)

func _on_damage_taken(amt, ctx):
	if not damage_number_scene:
		return
	
	var damage_number_instance = damage_number_scene.instantiate()
	damage_number_instance.bind(amt, ctx)
	damage_number_instance.global_position = global_position + Vector2(size.x / 2 - 5, size.y / 2 - 20)
	get_tree().current_scene.call_deferred("add_child", damage_number_instance)
