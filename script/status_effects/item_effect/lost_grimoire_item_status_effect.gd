extends ItemStatusEffect

var bonus_hand_size := 3

func on_battle_start(context: BattleContext, controller:BattleController):
	context.max_hand_size_bonus += bonus_hand_size
	
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.draw_card(bonus_hand_size)\
		.enqueue()
