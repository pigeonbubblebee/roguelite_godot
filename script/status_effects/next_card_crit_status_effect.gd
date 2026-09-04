class_name NextCardCritStatusEffect
extends StatusEffect

var crit_chance : float

var has_card := false
var current_card : Card

func _init(id: String, stacks: int = 1, bonus_chance := 0.5):
	super._init(id, stacks)
	
	crit_chance = bonus_chance
	
func get_is_turn_based() -> bool:
	return false
	
func before_card_played(card: Card, context: BattleContext, controller: BattleController):
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
		_context.add_critical_chance(crit_chance)
