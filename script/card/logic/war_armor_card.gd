class_name WarArmorCard
extends Card

var armor : int = 80

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)
	var player = context.get_player()
	
	var hand = controller.get_hand_manager().get_hand()
	var card_arr : Array[Card] = []
	for card in hand:
		if card.type == Card.CardType.ATTACK:
			card_arr.append(card)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(player, armor)\
		.modify_card_select(func(t): 
				return SharpnessModifier.new("sharpness_modifier"), card_arr)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
