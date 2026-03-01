class_name StatusEffect
extends RefCounted

var _owner : Actor
var _stacks : int
var _status_name : String

signal expired(status: StatusEffect)
signal stacks_changed(stacks: int)

func _init(id : String, owner: Actor, stacks : int = 1):
	_owner = owner
	_stacks = stacks
	_status_name = id
	
	stacks_changed.emit(_stacks)

func on_apply(_context: BattleContext, _controller: BattleController):
	_context.event_bus.before_damage_dealt.connect(before_damage_dealt)
	_context.event_bus.turn_ended.connect(on_turn_end)
	
func before_damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	pass
	
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
	
	if(get_is_turn_based()):
		_stacks -= 1
		stacks_changed.emit(_stacks)
		
		if(_stacks == 0):
			expired.emit(self)

func get_is_turn_based() -> bool:
	return true
	
func get_stacks() -> int:
	return _stacks
	
func get_name():
	return _status_name

func get_desc():
	return "Test Description"
