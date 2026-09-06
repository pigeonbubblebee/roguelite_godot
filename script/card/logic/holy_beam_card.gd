class_name HolyBeamCard
extends Card

var smite_card_id : String = "smite_card"
var damage : int = 40

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var hit_actors = context.get_selected_enemies_aoe(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.multi_damage(hit_actors, damage, 
			damage)\
		.add_card_to_hand(smite_card_id)
		
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
