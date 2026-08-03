class_name GrindCard
extends Card

var sharpen_stacks : int = 3

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	var player = context.get_player()
	
	var hand = controller.get_hand_manager().get_hand()
	var card_arr : Array[Card] = []
	for card in hand:
		if card.type == Card.CardType.ATTACK:
			card_arr.append(card)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.modify_card_select(func(t): 
				return SharpnessModifier.new("sharpness_modifier", sharpen_stacks), card_arr)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
