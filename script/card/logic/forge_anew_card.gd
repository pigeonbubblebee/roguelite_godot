class_name ForgeAnewCard
extends Card

var status_stacks : int = 5
var status_id : String = "rage_status"
var rage_card_id = "beserkers_fury_card"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var player = context.get_player()
	var effect = RageStatusEffect.new(status_id, 
		status_stacks)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	# I need to find a better way to do this, but the 2 seperate ESB is for rage sequencing
	# so the beserker fury gets added before sharpness
	if not preview:
		EffectSequenceBuilder.new(context, controller)\
			.as_card(self)\
			.use_action(custom_action)\
			.apply_status(player, effect)\
			.enqueue()
	
	custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.modify_cards([controller.get_hand_manager().get_card_in_play(rage_card_id)], func(t): 
			return SharpnessModifier.new("sharpness_modifier"))

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
