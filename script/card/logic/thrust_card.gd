class_name ThrustCard
extends Card

var damage : int = 75

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	var hit_actors: Array[Actor] = [ selected_enemy ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
	damage_context.source_name = "thrust_card"
	damage_context.add_tag(DamageContext.TAG_CARD)
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(selected_enemy))
	
	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
	
	controller.draw_card()
	
	var hand = controller.get_hand_manager().get_hand()
	var card_selection_context = CardSelectionContext.new(hand, CardSelectionContext.DISCARD_PROMPT)
	
	var selected_card : Card
	
	card_selection_context.finished.connect(func(selected_cards):
		if selected_cards:
			selected_card = selected_cards[0]
			
			controller.discard_card(selected_card)
	)
	
	controller.start_card_selection(card_selection_context)
