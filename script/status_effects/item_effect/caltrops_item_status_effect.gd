extends ItemStatusEffect

var status_id = "weakened_status"
var status_stacks := 1

func get_is_turn_based() -> bool:
	return false

func damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not _context.source is Card:
		return
		
	var sharpened := false
	for mod in _context.source.get_modifiers():
		if mod.get_id() == "sharpness_modifier":
			sharpened = true
	if not sharpened:
		return	
	
	var hit_actors = _context.hit_actors
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(battle_context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.apply_status_multi(hit_actors, func(t): 
				return DamageAmplificationStatusEffect.new(status_id, 
					status_stacks * _stacks, 
					DamageAmplificationStatusEffect.weakened_percent_bonus))\
		.enqueue()
