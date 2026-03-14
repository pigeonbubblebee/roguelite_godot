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
	
	var discard_selection_context = BattleRuntimeHelper.generate_discard_card_selection_context(context, controller)
	action.append_action(CardSelectionAction.new(discard_selection_context))
	
	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
	
	controller.draw_card()
	
	# Discards
	controller.start_card_selection(discard_selection_context)
