class_name ShieldBashCard
extends Card

#var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var damage = context.get_player().get_armor()
	
	var target = context.get_selected_enemy()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)
