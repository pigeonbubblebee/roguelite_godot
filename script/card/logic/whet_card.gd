class_name WhetCard
extends Card

var armor : int = 40

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var hand = controller.get_hand_manager().get_hand()
	var card_arr : Array[Card] = []
	for card in hand:
		if card.type == Card.CardType.ATTACK:
			card_arr.append(card)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	var player = context.get_player()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(player, armor)\
		.modify_cards(card_arr, func(t): 
				return SharpnessModifier.new("sharpness_modifier"))

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
