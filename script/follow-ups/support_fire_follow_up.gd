class_name SupportFireFollowUp
extends FollowUp

var damage : int = 40
var status_id: String = "daze_status"
var status_buildup : int = 1
var source_id : String = "support_fire_follow_up"
var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func execute(dmg_context: DamageContext, context: BattleContext, controller: BattleController):
	var target = dmg_context.hit_actors[0]
	var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_follow_up(self)\
		.damage(target, damage, damage_type)\
		.apply_status(target, effect)\
		.enqueue()

func get_follow_up_id() -> String:
	return source_id
