class_name ShieldBashCard
extends Card

var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var damage = context.get_player().get_armor()
	
	var target = context.get_selected_enemy()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.enqueue()
