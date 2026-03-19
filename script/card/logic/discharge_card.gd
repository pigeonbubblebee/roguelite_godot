class_name DischargeCard
extends Card

var damage : int = 40
var stacks : int = 3
var status_id : String = "storm_status"

var stacks_2 : int = 3
var status_id_2 : String = "discharge_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	if selected_enemy._processing_death:
		return
	
	var hit_actors: Array[Actor] = [ selected_enemy ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
	damage_context.source_name = "discharge_card"
	damage_context.add_tag(DamageContext.TAG_CARD)
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(selected_enemy))
	
	action.started.connect(func():
		controller.apply_damage(damage_context)
		
		var effect_storm = StormStatusEffect.new(status_id, 
		context.event_bus, stacks)
		
		var application_status_storm = StatusEffectApplicationContext.new(context.get_player(), 
			effect_storm, context.get_player())
		
		controller.apply_status(application_status_storm)
		
		var effect_shock = DischargeStatusEffect.new(status_id_2, stacks_2)
		
		var application_status_discharge = StatusEffectApplicationContext.new(context.get_player(), 
			effect_shock, context.get_player())
			
		controller.apply_status(application_status_discharge)
	)
	
	controller.enqueue_action(action)
