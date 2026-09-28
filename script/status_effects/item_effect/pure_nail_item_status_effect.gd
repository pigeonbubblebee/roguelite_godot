extends ItemStatusEffect

func on_turn_start(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)\
			.use_action(BattleRuntimeHelper.generate_light_camera_shake_action())\
			.lose_life(battle_context.get_player(), 10)\
			.draw_card()\
			.armor(battle_context.get_player(), 20)\
			.enqueue()
			
func on_battle_start(battle_context: BattleContext, controller:BattleController):
	EffectSequenceBuilder.new(battle_context, controller)\
		.as_status(self)\
		.use_action(BattleRuntimeHelper.generate_light_camera_shake_action())\
		.lose_life(battle_context.get_player(), 10)\
		.draw_card()\
		.armor(battle_context.get_player(), 20)\
		.enqueue()
