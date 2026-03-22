class_name StormFollowUp
extends FollowUp

var damage : int = 8
const DAMAGE_SOURCE_NAME : String = "storm_follow_up"
var stacks : int = 1
var damage_type : DamageType.Type = DamageType.Type.LIGHTNING

func _init(_stacks : int):
	stacks = _stacks

func execute(dmg_context: DamageContext, context: BattleContext, controller: BattleController):
	var targets = dmg_context.hit_actors
	var final_damage = damage * stacks
	
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()\
		.set_priority(1)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_follow_up(self)\
		.use_action(custom_action)\
		.multi_damage(targets, final_damage, 
			damage_type, final_damage)\
		.enqueue()

func get_follow_up_id() -> String:
	return DAMAGE_SOURCE_NAME
