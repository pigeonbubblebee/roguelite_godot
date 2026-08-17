class_name RotCard
extends Card

var damage : int = 40

func bind_event_bus(bus):
	super.bind_event_bus(bus)
	
	event_bus.turn_ended.connect(on_turn_end)
	
func display_cost():
	return false

func can_play(context: BattleContext) -> bool:
	return false

func on_turn_end(actor: Actor, context: BattleContext, controller: BattleController):
	if actor == context.get_player():
		var hand = controller.get_hand_manager().get_hand()
		
		if not hand.has(self):
			return
			
		var target = context.get_player()
		
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		
		EffectSequenceBuilder.new(context, controller)\
			.as_wound(self)\
			.use_action(custom_action)\
			.damage(target, damage)\
			.discard_without_selection(self)\
			.enqueue()
			
		await context.await_battle_actions()
