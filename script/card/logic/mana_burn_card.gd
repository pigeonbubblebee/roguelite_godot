class_name ManaBurnCard
extends Card

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func bind_event_bus(bus):
	super.bind_event_bus(bus)
	
	bus.turn_ended.connect(_on_turn_end)
	
func display_cost():
	return false

func can_play(context: BattleContext) -> bool:
	return false
	
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
