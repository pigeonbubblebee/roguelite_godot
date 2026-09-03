class_name SupportFireFollowUp
extends FollowUp

var damage : int = 40

var source_id : String = "support_fire_follow_up"

func execute(dmg_context: DamageContext, context: BattleContext, controller: BattleController):
	var target = dmg_context.hit_actors[0]
	
	EffectSequenceBuilder.new(context, controller)\
		.as_follow_up(self)\
		.damage(target, damage)\
		#.apply_status(target, effect)\
		.enqueue()

func get_follow_up_id() -> String:
	return source_id
