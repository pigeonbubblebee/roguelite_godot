extends ItemStatusEffect

var armor = 5

func on_turn_start(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		var statuses = actor.get_status_manager().get_active_status()
		
		for status in statuses:
			if status.get_status_id() == "resolve_status":
				var custom_action = BattleRuntimeHelper.generate_basic_defense_action(battle_context)

				EffectSequenceBuilder.new(battle_context, controller)\
					.as_status(self)\
					.use_action(custom_action)\
					.armor(battle_context.get_player(), armor * _stacks * status.get_stacks())\
					.enqueue()
