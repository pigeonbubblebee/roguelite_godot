extends ItemStatusEffect

var status_turns : int = 1
var status_id : String = "vulnerable_status"

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	var hit_actors = _context.get_actors_of_faction(Faction.Type.ENEMY)
	EffectSequenceBuilder.new(_context, _controller)\
		.as_status(self)\
		.apply_status_multi(hit_actors, func(t): 
			return DamageTakenAmplificationStatusEffect.new(
			status_id, 
			status_turns))\
		.enqueue()
