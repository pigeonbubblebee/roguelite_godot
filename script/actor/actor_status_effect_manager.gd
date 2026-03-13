class_name ActorStatusEffectManager
extends RefCounted

var _active_status_effects : Array[StatusEffect]

signal status_updated(status_effects: Array[StatusEffect])

func apply_status(status : StatusEffect, context: BattleContext, controller: BattleController):
	for _status in _active_status_effects:
		if _status._status_id == status._status_id:
			_status.add_stacks(status.get_stacks())
			return
	
	_active_status_effects.append(status)
	status.stacks_changed.connect(on_stacks_changed)
	status.expired.connect(on_status_expired)
	status.on_apply(context, controller)
	
	status_updated.emit(_active_status_effects)
	
func on_status_expired(status: StatusEffect):
	_active_status_effects.erase(status)
	
	status_updated.emit(_active_status_effects)

func get_active_status() -> Array[StatusEffect]:
	return _active_status_effects

func on_stacks_changed(stacks):
	status_updated.emit(_active_status_effects)
