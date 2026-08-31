class_name PurifyCard
extends Card

var smite_amount : int = 3
var smite_card_id : String = "smite_card"

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()

	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.add_card_to_hand(smite_card_id, smite_amount)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
