extends ItemStatusEffect

var status_turns : int = 1
var status_id : String = "daze_status"

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	var hit_actors = _context.get_actors_of_faction(Faction.Type.ENEMY)
	EffectSequenceBuilder.new(_context, _controller)\
		.as_status(self)\
		.apply_status_multi(hit_actors, func(t): 
			return DazeStatusEffect.new(
			status_id, 
			_context.get_player(),
			status_turns))\
		.enqueue()
		
func before_damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not _context.source is StatusEffect:
		return
	if not _context.source.get_status_id() == "daze_status":
		return
	
	_context.add_damage_percent(1)
