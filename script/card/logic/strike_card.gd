class_name StrikeCard
extends Card

var damage : int = 50

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	var hit_actors: Array[Actor] = [ selected_enemy ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors)	
	damage_context.source_name = "strike_card"
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(selected_enemy))
	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
