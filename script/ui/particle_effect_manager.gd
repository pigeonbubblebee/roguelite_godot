class_name ParticleEffectManager
extends Node

@export var slash_effect: PackedScene
@export var magic_slash_effect: PackedScene
@export var armor_effect: PackedScene

@onready var effect_map: Dictionary = {
	"slash": slash_effect,
	"magic_slash": magic_slash_effect,
	"armor": armor_effect
}

# Spawns particle effect as a child of target node, returns the instance
func spawn_effect(effect_name: String, parent: Node, position: Vector2) -> Node2D:
	if not effect_map.has(effect_name):
		push_warning("No particle effect found for: %s" % effect_name)
		return null
	
	var particle_instance = effect_map[effect_name].instantiate() as Node2D
	parent.add_child(particle_instance)
	
	var offset = Vector2(parent.size.x / 2, parent.size.y / 2)
	
	particle_instance.global_position = position + offset
	
	return particle_instance
