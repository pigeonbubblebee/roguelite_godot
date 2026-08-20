class_name GrievousWoundsEffect
extends StatusEffect

var multiplier : int = 10 # might by default

func _init(id: String, _stacks: int = 1, _mult: float = 10):
	super._init(id, _stacks)

	multiplier = _mult

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		var amt = 0
		var deck = controller.get_hand_manager().get_all_cards_in_play()
		
		for card in deck:
			if card.type == Card.CardType.WOUND:
				amt += 1
		
		context.add_damage_flat(_stacks * multiplier * amt)
		
func on_card_added_to_deck(card: Card, context: BattleContext, controller: BattleController):
	controller.request_premove_refresh()
	
func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	controller.request_premove_refresh()

func get_is_turn_based() -> bool:
	return false
