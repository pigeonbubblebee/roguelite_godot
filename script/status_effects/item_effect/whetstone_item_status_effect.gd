extends ItemStatusEffect

# empowered by default
func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	
	var hand = _controller.get_hand_manager().get_hand()
	var card_arr : Array[Card] = []
	for card in hand:
		if card.type == Card.CardType.ATTACK:
			card_arr.append(card)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	var player = _context.get_player()
	
	EffectSequenceBuilder.new(_context, _controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.modify_cards(card_arr, func(t): 
				return SharpnessModifier.new("sharpness_modifier"))\
		.enqueue()
