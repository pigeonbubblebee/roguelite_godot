class_name SupportFireFollowUp
extends FollowUp

var damage : int = 50
var status_id: String = "daze_status"
var status_buildup : int = 2

func execute(dmg_context: DamageContext, context: BattleContext, controller: BattleController):
	if dmg_context.hit_actors[0]._processing_death:
		return
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(dmg_context.hit_actors[0]))
	controller.enqueue_action(action)
	
	action.started.connect(func():
		var hit_actors: Array[Actor] = [ dmg_context.hit_actors[0] ]
		
		var effect = DazeStatusEffect.new(status_id, dmg_context.hit_actors[0], status_buildup)
		var application_status = StatusEffectApplicationContext.new(dmg_context.hit_actors[0], effect, context.get_player())
		controller.apply_status(application_status)
		
		var damage_context = BattleRuntimeHelper.generate_damage_context(damage, 
			hit_actors, context.get_player())	
		damage_context.source_name = SupportFireCard.SUPPORT_FIRE_DAMAGE_SOURCE_NAME
		damage_context.add_tag(DamageContext.TAG_FOLLOW_UP)
		
		controller.apply_damage(damage_context)
		
		
	)
