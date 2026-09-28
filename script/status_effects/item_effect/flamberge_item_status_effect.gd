extends ItemStatusEffect

var status_buildup : int = 1
var status_id : String = "bleed_status"

func damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if _context.damage_owner == _owner:
		var hit_actors = _context.hit_actors
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)\
			.use_action(BattleRuntimeHelper.generate_light_camera_shake_action())\
			.apply_status_multi(hit_actors, func(t): 
					return BleedStatusEffect.new(status_id, 
					battle_context.get_player(), status_buildup))\
			.enqueue()
