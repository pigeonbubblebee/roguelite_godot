class_name ArmamentsStatusEffect
extends StatusEffect

func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	var amt = 0
	for m in card.get_modifiers():
		if m.id == "sharpness_modifier":
			amt += m.stacks
	
	if amt == 0:
		return
	
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)

	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.armor(context.get_player(), ArmamentsCard.ARMOR_AMOUNT * _stacks * amt)\
		.enqueue()
	
func get_is_turn_based() -> bool:
	return false
