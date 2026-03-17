class_name OpportuneBlowCard
extends Card

var damage : int = 30
var multistrike_amount : int = 3

var status_type : String = "Debuff"

func get_keywords() -> Array[String]:
	return [ "Multistrike 3" ]

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	var status = selected_enemy.get_status_manager().get_active_status()
	
	var actual_amount = 1
	
	for st in status:
		print(st.status_type)
		if st.status_type == status_type:
			actual_amount = 3
	
	for i in range(actual_amount):
		if selected_enemy._processing_death:
			return
		
		var action = BattleRuntimeHelper.generate_basic_attack_action(context)
		action.append_action(PlayParticleEffectAction.new(selected_enemy))
		
		controller.enqueue_action( action )
		
		var hit_actors: Array[Actor] = [ selected_enemy ]
		
		var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
		damage_context.source_name = "opportune_blow_card"
		damage_context.add_tag(DamageContext.TAG_CARD)
		
		controller.apply_damage(damage_context)
		
		if i == actual_amount - 1:
			continue
		
		await context.await_battle_actions()
		
	
