class_name GashCard
extends Card

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.draw_card()

func bind_event_bus(bus):
	super.bind_event_bus(bus)
	
	bus.turn_ended.connect(_on_turn_end)
	
func _on_turn_end(actor, context, controller):
	if not actor == context.get_player():
		return
	
	var hand = controller.get_hand_manager().get_hand()
		
	if not hand.has(self):
		return

	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.remove_without_selection(self)\
		.enqueue()
