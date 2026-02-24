class_name QuickStrikeCard
extends Card

var damage : int = 40
var multistrike_amount : int = 3

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	var actions : Array[BattleVisualAction] = []
	
	for i in range(multistrike_amount):
		var action = CardRuntimeHelper.generate_basic_attack_action(context)
		actions.append(action)
		
		action.append_action(PlayParticleEffectAction.new(selected_enemy))
		
		controller.enqueue_action( action )
		
	
	for i in range(multistrike_amount):
		var hit_actors: Array[Actor] = [ selected_enemy ]
		
		var damage_context = CardRuntimeHelper.generate_damage_context(damage, hit_actors)	
		damage_context.source_name = "quick_strike_card"
		
		controller.apply_damage(damage_context)
		
		if i == multistrike_amount - 1:
			continue
		
		await actions[i].finished
		
	
