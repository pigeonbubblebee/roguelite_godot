class_name StatusEffect
extends RefCounted

var _owner : Actor
var _stacks : int
var _status_id : String
var status_name : String
var status_type : String
var _description : String
var _icon_type : String

signal expired(status: StatusEffect)
signal stacks_changed(stacks: int)

func _init(id : String, owner: Actor, stacks : int = 1):
	_owner = owner
	_stacks = stacks
	_status_id = id
	
	var status = StatusEffectDatabase.get_status_effect(_status_id)
	
	_icon_type = status["ICON_TYPE"]
	status_name = status["STATUS_EFFECT_NAME"]
	status_type = status["STATUS_TYPE"]
	_description = status["DESCRIPTION"]
	
	stacks_changed.emit(_stacks)
	
func add_stacks(amt : int):
	_stacks += amt
	stacks_changed.emit(_stacks)

func on_apply(_context: BattleContext, _controller: BattleController):
	_context.event_bus.before_damage_dealt.connect(before_damage_dealt)
	_context.event_bus.turn_ended.connect(on_turn_end)
	_context.event_bus.turn_started.connect(on_turn_start)
	
func before_damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	pass
	
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
	
	if(get_is_turn_based()):
		reduce_stacks()
			
func reduce_stacks(amount : int = 1):
	_stacks -= amount
	stacks_changed.emit(_stacks)
		
	if(_stacks <= 0):
		expired.emit(self)
			
func on_turn_start(actor: Actor, battle_context: BattleContext, controller: BattleController):
	pass

func get_is_turn_based() -> bool:
	return true
	
func get_stacks() -> int:
	return _stacks
	
func get_name():
	return status_name
	
func get_status_id():
	return _status_id

func get_description():
	return KeywordFormatter.format_status_description(_description, _stacks)
	
func get_icon_type():
	return _icon_type
