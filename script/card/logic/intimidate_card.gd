class_name IntimidateCard
extends Card

var status_turns : int = 1
var status_id : String = "vulnerable_status"

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var hit_actors = context.get_selected_enemies_aoe()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.apply_status_multi(hit_actors, func(t): 
			return DamageTakenAmplificationStatusEffect.new(
			status_id, 
			status_turns))\
		.enqueue()
		
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
