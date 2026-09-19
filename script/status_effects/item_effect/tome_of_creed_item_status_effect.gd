extends ItemStatusEffect

func on_battle_start(context: BattleContext, controller:BattleController):
	var player = context.get_player()
	var effect = DamageAmplificationStatusEffect.new("empowered_status", 
		6)
	var effect2 = ArmorAmplificationStatusEffect.new("fortitude_status", 
		2, ArmorAmplificationStatusEffect.fortitude_percent_bonus)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.apply_status(player, effect)\
		.apply_status(player, effect2)\
		.enqueue()
