class_name SunderingStrikeCard
extends Card

var damage : int = 70
var status_buildup : int = 4
var status_id : String = "daze_status"
var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()

	var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.apply_status(target, effect)\
		.enqueue()
