class_name StormFollowUp
extends FollowUp

var damage : int = 8
const DAMAGE_SOURCE_NAME : String = "storm_follow_up"
var stacks : int = 1

func _init(_stacks : int):
	stacks = _stacks

func execute(dmg_context: DamageContext, context: BattleContext, controller: BattleController):
	if dmg_context.hit_actors[0]._processing_death:
		return
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(dmg_context.hit_actors[0]))
	#action.append_action(CardArtAction.new(context.get_player(), card_id))
	controller.enqueue_action(action)
	
	action.started.connect(func():
		var hit_actors: Array[Actor] = [ dmg_context.hit_actors[0] ]
		
		var final_damage = damage * stacks
		
		var damage_context = BattleRuntimeHelper.generate_damage_context(final_damage, 
			hit_actors, context.get_player())	
		damage_context.source_name = DAMAGE_SOURCE_NAME
		damage_context.damage_type = DamageType.Type.LIGHTNING
		damage_context.add_tag(DamageContext.TAG_FOLLOW_UP)
		
		controller.apply_damage(damage_context)
	)
