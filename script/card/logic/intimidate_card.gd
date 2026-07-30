class_name IntimidateCard
extends Card

var status_turns : int = 1
var status_id : String = "vulnerable_status"

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var hit_actors = context.get_selected_enemies_aoe(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.apply_status_multi(hit_actors, func(t): 
			return DamageTakenAmplificationStatusEffect.new(
			status_id, 
			status_turns))
		
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
