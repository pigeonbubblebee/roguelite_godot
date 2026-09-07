class_name SongOfProtectionCard
extends Card

var armor : int = 60
var modifier_amount : int = 4

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var hit_actors = context.get_selected_enemies_aoe(preview)
	
	var sequence = EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.armor(context.get_player(), armor)

	var hand = controller.get_hand_manager().get_hand()
		
	for i in range(modifier_amount):
		var random_card = hand.pick_random()
		sequence.modify_cards([random_card], func(t): return SymphonyModifier.new("symphony_modifier", 1))
	
	return sequence
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
