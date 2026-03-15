class_name ShieldBashCard
extends Card

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	if selected_enemy._processing_death:
		return
	
	var damage = context.get_player().get_armor()
	
	var hit_actors: Array[Actor] = [ selected_enemy ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
	damage_context.source_name = "strike_card"
	damage_context.add_tag(DamageContext.TAG_CARD)
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(selected_enemy))
	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
