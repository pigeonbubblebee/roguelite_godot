class_name ActorPremove
extends RefCounted

var amount : int
var actor : Actor

signal finished

func _init(_actor : Actor):
	actor = _actor

const ATTACK_ICON := preload("res://assets/ui/enemy_moves/attack_move.png")
const ARMOR_ICON := preload("res://assets/ui/enemy_moves/armor_move.png")

func get_amount():
	return str(amount)
	
func clone() -> ActorPremove:
	push_error("clone() must be implemented by subclasses")
	var copy = ActorPremove.new(actor)
	return copy

func execute(context: BattleContext, controller: BattleController):
	push_error("execute() must be implemented by subclasses")
	finished.emit()
	pass

func get_icon() -> Texture2D:
	push_error("get_icon() must be implemented by subclasses")
	return ATTACK_ICON
	pass
