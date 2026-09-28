extends ItemStatusEffect

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		var total_count = 0
		var sequence = EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)
		
		for enemy in battle_context.get_actors_of_faction(Faction.Type.ENEMY):
			var count = 0
			for status in enemy.get_status_manager().get_active_status():
				if status.status_type == StatusEffect.TYPE_DEBUFF and status.get_is_visible():
					count += 1
					
			if count > 0:
				sequence.damage(enemy, count * 10)
			total_count += count
		
		if total_count > 0:		
			sequence.enqueue()
