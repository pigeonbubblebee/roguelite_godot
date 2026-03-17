class_name StatusEffectApplicationContext
extends RefCounted

var actor: Actor
var status: StatusEffect
var source

func _init(_actor, _status, _source = null):
	actor = _actor
	status = _status
	source = _source
