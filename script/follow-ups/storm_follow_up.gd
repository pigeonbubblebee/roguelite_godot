class_name StormFollowUp
extends FollowUp

var damage : int = 8
const DAMAGE_SOURCE_NAME : String = "storm_follow_up"
var stacks : int = 1

func _init(_stacks : int):
	stacks = _stacks

func execute(dmg_context: DamageContext, context: BattleContext, controller: BattleController):
	var targets = dmg_context.hit_actors
	var final_damage = damage * stacks
	
	var custom_action = BattleRuntimeHelper.generate_storm_action(context, targets)\
		.set_priority(1)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_follow_up(self)\
		.use_action(custom_action)\
		.multi_damage(targets, final_damage, 
			final_damage)\
		.enqueue()

func get_follow_up_id() -> String:
	return DAMAGE_SOURCE_NAME
