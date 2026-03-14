class_name QuickStrikeCard
extends Card

var damage : int = 40
var multistrike_amount : int = 2

func get_keywords() -> Array[String]:
	return [ "Multistrike 2" ]

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	for i in range(multistrike_amount):
		var action = BattleRuntimeHelper.generate_basic_attack_action(context)
		action.append_action(PlayParticleEffectAction.new(selected_enemy))
		
		controller.enqueue_action( action )
		
		var hit_actors: Array[Actor] = [ selected_enemy ]
		
		var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
		damage_context.source_name = "quick_strike_card"
		
		controller.apply_damage(damage_context)
		
		if i == multistrike_amount - 1:
			continue
		
		await context.await_battle_actions()
		
	
