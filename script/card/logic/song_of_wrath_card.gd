class_name SongOfWrathCard
extends Card

var damage : int = 80
var modifier_amount : int = 2

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var hit_actors = context.get_selected_enemies_aoe(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.multi_damage(hit_actors, damage, damage)\
		.modify_card_select(func(t): 
				return SymphonyModifier.new("symphony_modifier", 2), controller.get_hand_manager().get_hand())
		
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
