class_name SymphonyStatusEffect
extends StatusEffect

var damage := 20

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		
		
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.multi_damage(battle_context.get_actors_of_faction(Faction.Type.ENEMY), damage * _stacks, 
				damage * _stacks)\
			.enqueue()
			
		reduce_stacks(_stacks)
				
func get_is_turn_based() -> bool:
	return false
