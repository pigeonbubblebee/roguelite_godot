extends ItemStatusEffect

func on_card_added_to_deck(card: Card, context: BattleContext, controller: BattleController):
	if card.id == "mana_burn_card":
		var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)

		EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.add_card_to_hand("mana_crystal_card")\
			.enqueue()
