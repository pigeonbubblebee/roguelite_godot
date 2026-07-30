class_name HonedEdgeCard
extends Card

var damage : int = 70

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.modify_cards([self], func(t): 
				return SharpnessModifier.new("sharpness_modifier"))
