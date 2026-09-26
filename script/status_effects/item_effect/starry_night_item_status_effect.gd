extends ItemStatusEffect

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor != _owner:
		return
		
	for card in controller.get_hand_manager().get_hand():
		if card.id == "mana_burn_card":
			var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
			var player = battle_context.get_player()
			
			EffectSequenceBuilder.new(battle_context, controller)\
				.as_status(self)\
				.use_action(custom_action)\
				.remove_without_selection(card)\
				.add_card_to_hand("magic_missile_card")\
				.enqueue()
			return
