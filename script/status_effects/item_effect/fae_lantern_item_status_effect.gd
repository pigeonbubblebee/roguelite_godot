extends ItemStatusEffect

var bonus_flat := 40
var has_card := false
var current_card : Card

var triggered := false
	
func get_is_turn_based() -> bool:
	return false
	
func before_card_played(card: Card, context: BattleContext, controller: BattleController):
	if triggered:
		return
	
	triggered = true
	
	if card.type == Card.CardType.ATTACK:
		has_card = true
		current_card = card
		
func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	if card == current_card:
		has_card = false
		current_card = null
		reduce_stacks()

func before_damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if has_card and _context.damage_owner == _owner:
		_context.add_damage_flat(bonus_flat)
		
		
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_end(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
