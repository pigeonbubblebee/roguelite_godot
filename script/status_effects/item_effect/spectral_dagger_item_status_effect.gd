extends ItemStatusEffect

func status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	if ctx.status.get_status_id() == "weakened_status":
		EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.use_action(BattleRuntimeHelper.generate_light_camera_shake_action())\
			.apply_status(ctx.actor, CorruptedStatusEffect.new("corrupted_status"))\
			.enqueue()
