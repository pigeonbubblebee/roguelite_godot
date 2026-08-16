extends ItemStatusEffect

var armor := 60

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		if actor.get_armor() == 0:
			var custom_action = BattleRuntimeHelper.generate_basic_defense_action(battle_context)

			EffectSequenceBuilder.new(battle_context, controller)\
				.as_status(self)\
				.use_action(custom_action)\
				.armor(battle_context.get_player(), armor)\
				.enqueue()
