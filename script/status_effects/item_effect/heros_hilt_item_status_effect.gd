extends ItemStatusEffect

var damage := 70

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	var hit_actors = _context.get_actors_of_faction(Faction.Type.ENEMY)
	EffectSequenceBuilder.new(_context, _controller)\
		.as_status(self)\
		.multi_damage(hit_actors, damage, damage)\
		.enqueue()
