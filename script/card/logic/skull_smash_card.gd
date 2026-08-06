class_name SkulLSmashCard
extends Card

var damage : int = 60
var blast_damage : int = 30
var status_turns : int = 1
var status_id : String = "daze_status"

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var hit_actors = context.get_selected_enemies_blast(preview)
	var custom_action = BattleRuntimeHelper.generate_heavy_attack_action(context)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.multi_damage(hit_actors, damage, blast_damage)\
		.apply_status_multi(hit_actors, func(t): 
				return DazeStatusEffect.new(status_id,context.get_player(), status_turns))
	
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_blast(total_targets, target_index)
