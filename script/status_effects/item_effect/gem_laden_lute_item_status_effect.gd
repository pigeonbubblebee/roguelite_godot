extends ItemStatusEffect

func on_card_added_to_deck(card: Card, context: BattleContext, controller: BattleController):
	if card.id == "mana_crystal_card":
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.modify_cards([card], func(t): return SymphonyModifier.new("symphony_modifier", 1))\
			.enqueue()
