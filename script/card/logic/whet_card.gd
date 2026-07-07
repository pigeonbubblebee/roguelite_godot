class_name WhetCard
extends Card

var armor : int = 60

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var hand = controller.get_hand_manager().get_hand()
	var card_arr : Array[Card] = []
	for card in hand:
		if card.type == Card.CardType.ATTACK:
			card_arr.append(card)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	var player = context.get_player()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.modify_cards(card_arr, func(t): 
				return SharpnessModifier.new("sharpness_modifier"))\
		.enqueue()

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
