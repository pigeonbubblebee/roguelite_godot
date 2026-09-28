extends ItemStatusEffect

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not context.source is StatusEffect:
		return
	if not context.source.get_status_id() == "ritual_status":
		return
	
	if context.damage_owner == _owner:
		context.add_damage_percent(0.3)

func damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not context.source is StatusEffect:
		return
	if not context.source.get_status_id() == "ritual_status":
		return
	
	if context.damage_owner == _owner:
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)\
			.use_action(BattleRuntimeHelper.generate_light_camera_shake_action())\
			.lose_life(battle_context.get_player(), 30)\
			.enqueue()
