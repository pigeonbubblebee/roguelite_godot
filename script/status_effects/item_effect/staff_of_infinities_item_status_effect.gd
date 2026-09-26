extends ItemStatusEffect

var stacks := 0

func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	if card.id == "mana_crystal_card":
		stacks += 1
		
	if stacks >= 4:
		var deck = controller.get_hand_manager().get_deck()
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		
		EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.modify_cards([deck[0]], func(t): 
					return FreeToPlayModifier.new("free_to_play_modifier", 1))\
			.enqueue()
		stacks = 0
