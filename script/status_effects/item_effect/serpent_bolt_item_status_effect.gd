extends ItemStatusEffect

var stacks : int = 1
var status_id : String = "storm_status"

func damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if _context.damage_owner == _owner and _context.landed_critical:
		var player = battle_context.get_player()
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		var effect = StormStatusEffect.new(status_id, 
			battle_context.event_bus, 
			stacks)
		
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.apply_status(player, effect)\
			.enqueue()
