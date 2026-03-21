class_name ThrustCard
extends Card

var damage : int = 75
var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.draw_card()\
		.discard_card()\
		.enqueue()
