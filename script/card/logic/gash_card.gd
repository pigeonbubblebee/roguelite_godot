class_name GashCard
extends Card

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.draw_card()\
		.enqueue()
