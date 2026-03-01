class_name ActorStatusEffectManager
extends RefCounted

var _active_status_effects : Array[StatusEffect]

signal status_updated(status_effects: Array[StatusEffect])

func apply_status(status : StatusEffect, context: BattleContext, controller: BattleController):
	_active_status_effects.append(status)
	status.expired.connect(on_status_expired)
	status.on_apply(context, controller)
	
	status_updated.emit(_active_status_effects)
	
func on_status_expired(status: StatusEffect):
	_active_status_effects.erase(status)
	
	status_updated.emit(_active_status_effects)

func get_active_status() -> Array[StatusEffect]:
	return _active_status_effects
