class_name StatusEffect
extends RefCounted

var _owner : Actor
var _stacks : int
var _status_id : String
var status_name : String
var status_type : String
var _description : String
var _icon_type : String

var _battle_context : WeakRef

signal expired(status: StatusEffect)
signal stacks_changed(stacks: int)

static var TYPE_BUFF = "Buff"
static var TYPE_DEBUFF = "Debuff"

func _init(id : String, stacks : int = 1):
	_stacks = stacks
	_status_id = id
	
	var status = StatusEffectDatabase.get_status_effect(_status_id)
	
	_icon_type = status["ICON_TYPE"]
	status_name = status["STATUS_EFFECT_NAME"]
	status_type = status["STATUS_TYPE"]
	_description = status["DESCRIPTION"]
	
	stacks_changed.emit(_stacks)
	
func set_owner(owner : Actor):
	_owner = owner
	
func add_stacks(amt : int):
	_stacks += amt
	stacks_changed.emit(_stacks)

func on_apply(context: BattleContext, _controller: BattleController):
	_battle_context = weakref(context)
	_set_event_connections(context.event_bus, true)

func cleanup():
	var context = _battle_context.get_ref()
	if context == null:
		return
	
	_set_event_connections(context.event_bus, false)
	_battle_context = null


func _set_event_connections(event_bus, connect_events: bool):
	var events = [
		[event_bus.before_damage_dealt, before_damage_dealt],
		[event_bus.resolve_damage, resolve_damage],
		[event_bus.damage_dealt, damage_dealt],
		[event_bus.before_armor_applied, before_armor_applied],
		[event_bus.armor_applied, armor_applied],
		[event_bus.turn_ended, on_turn_end],
		[event_bus.turn_started, on_turn_start],
		[event_bus.turn_started_after_action, on_turn_started_after_action],
		[event_bus.actor_died, on_actor_died],
		[event_bus.on_card_played, on_card_played],
		[event_bus.modifier_applied, modifier_applied],
		[event_bus.before_modifier_applied, before_modifier_applied],
		[event_bus.card_cost_request, card_cost_request],
		[event_bus.before_card_played, before_card_played],
		[event_bus.status_applied, status_applied],
		[event_bus.before_status_applied, before_status_applied],
		[event_bus.on_card_added_to_deck, on_card_added_to_deck],
		[event_bus.on_card_discarded, on_card_discarded],
	]
	
	for event in events:
		if connect_events:
			event[0].connect(event[1])
		else:
			event[0].disconnect(event[1])

func card_cost_request(ctx: CardCostRequestContext):
	pass
	
func on_card_discarded(card : Card, context: BattleContext, controller: BattleController):
	pass
	
func status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	pass
	
func before_status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	pass
	
func modifier_applied(card: Card, mod: CardModifier, context: BattleContext, controller: BattleController):
	pass
	
func before_modifier_applied(card: Card, mod: CardModifier, context: BattleContext, controller: BattleController):
	pass

func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	pass
	
func before_card_played(card: Card, context: BattleContext, controller: BattleController):
	pass
	
func on_card_added_to_deck(card: Card, context: BattleContext, controller: BattleController):
	pass

func stacks_updated(_context: BattleContext, _controller: BattleController):
	pass
	
func before_damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	pass
	
func resolve_damage(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	pass
	
func damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	pass
	
func before_armor_applied(_context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	pass
	
func armor_applied(_context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	pass
	
func on_actor_died(actor: Actor, context: BattleContext, controller: BattleController):
	pass
	
func on_turn_started_after_action(actor: Actor, battle_context: BattleContext, controller: BattleController):
	pass
	
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
	
	if(get_is_turn_based()):
		reduce_stacks()
			
func reduce_stacks(amount : int = 1):
	_stacks -= amount
		
	if(_stacks <= 0):
		expired.emit(self)
	else:
		stacks_changed.emit(_stacks)
			
func on_turn_start(actor: Actor, battle_context: BattleContext, controller: BattleController):
	pass

func get_is_turn_based() -> bool:
	return true
	
func get_is_visible() -> bool:
	return true
	
func get_stacks() -> int:
	return _stacks
	
func set_stacks(amount : int):
	_stacks = amount
	
	if(_stacks <= 0):
		expired.emit(self)
	else:
		stacks_changed.emit(_stacks)
	
func get_name():
	return status_name
	
func get_status_id():
	return _status_id

func get_description():
	return KeywordFormatter.format_status_description(_description, _stacks)
	
func get_icon_type():
	return _icon_type
