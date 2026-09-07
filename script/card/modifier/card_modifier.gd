class_name CardModifier
extends RefCounted

var stacks : int = 0
var id : String = ""

var _owner : Card

func _init(_id : String, _stacks : int = 1):
	id = _id
	stacks = _stacks
	
func get_selection_prompt():
	return CardSelectionContext.SHARPEN_PROMPT
	
func get_stacks():
	return stacks
	
func get_id():
	return id

func set_owner(owner : Card):
	_owner = owner

func on_apply(card: Card, context:BattleContext, controller:BattleController):
	context.event_bus.before_damage_dealt.connect(before_damage_dealt)
	context.event_bus.on_card_played.connect(on_card_played)

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	pass
	
func on_card_played(card: Card, battle_context: BattleContext, controller: BattleController):
	pass

func get_name():
	return ""
