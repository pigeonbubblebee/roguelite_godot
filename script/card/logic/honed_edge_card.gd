class_name HonedEdgeCard
extends Card

var damage : int = 50

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	if preview:
		return EffectSequenceBuilder.new(context, controller)\
			.as_card(self)\
			.damage(target, damage)
	else:
		var dmg_dict = preview_damage(context, controller)
		var dmg = dmg_dict[target]
		
		return EffectSequenceBuilder.new(context, controller)\
			.as_card(self)\
			.damage(target, damage)\
			.armor(context.get_player(), int(dmg))
