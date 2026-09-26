extends ItemStatusEffect

var armor = 10

func damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(battle_context)

	EffectSequenceBuilder.new(battle_context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.armor(battle_context.get_player(), armor)\
		.enqueue()
