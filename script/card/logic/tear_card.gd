class_name TearCard
extends Card

var damage : int = 40
var status_buildup : int = 2
var status_id : String = "bleed_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var hit_actors = context.get_selected_enemies_aoe(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.multi_damage(hit_actors, damage, damage)\
		.apply_status_multi(hit_actors, func(t): 
				return BleedStatusEffect.new(status_id, 
				context.get_player(), status_buildup))
		
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
