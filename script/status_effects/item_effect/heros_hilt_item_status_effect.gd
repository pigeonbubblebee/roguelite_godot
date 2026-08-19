extends ItemStatusEffect

var damage := 70

func on_battle_start(_context: BattleContext, _controller: BattleController):
	var hit_actors = _context.get_actors_of_faction(Faction.Type.ENEMY)
	EffectSequenceBuilder.new(_context, _controller)\
		.as_status(self)\
		.multi_damage(hit_actors, damage, damage)\
		.enqueue()
