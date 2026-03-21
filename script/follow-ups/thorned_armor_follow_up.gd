class_name ThornedArmorFollowUp
extends FollowUp

var damage : int = 30
var source_id : String = "thorned_armor_follow_up"
var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func execute(dmg_context: DamageContext, context: BattleContext, controller: BattleController):
	var target : Actor
	
	if dmg_context.damage_owner is Actor:
		target = dmg_context.damage_owner
	else:
		# implement getting a random actor from the faction
		push_error("Thorned Armor cannot find target!")
		return
	
	EffectSequenceBuilder.new(context, controller)\
		.as_follow_up(self)\
		.damage(target, damage, damage_type)\
		.enqueue()

func get_follow_up_id() -> String:
	return source_id
