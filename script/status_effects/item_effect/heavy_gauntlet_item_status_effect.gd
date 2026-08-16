extends ItemStatusEffect

var status_id = "daze_status"
var status_stacks := 1

func get_is_turn_based() -> bool:
	return false

func damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not _context.source is Card:
		return
	if _context.source.get_base_cost() < 2:
		return
	
	var hit_actors = _context.hit_actors
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(battle_context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.apply_status_multi(hit_actors, func(t): 
				return DazeStatusEffect.new(status_id, 
					battle_context.get_player(), status_stacks * _stacks))\
		.enqueue()
