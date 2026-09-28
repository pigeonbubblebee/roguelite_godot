extends ItemStatusEffect

func on_lose_life(actor: Actor, amount: int, context : BattleContext, controller : BattleController):
	if actor == _owner:
		var hit_actors = context.get_actors_of_faction(Faction.Type.ENEMY)
		var target = hit_actors.pick_random()
		EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.heal_actor(_owner, amount)\
			.damage(target, amount)\
			.enqueue()
