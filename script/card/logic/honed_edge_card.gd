class_name HonedEdgeCard
extends Card

var damage : int = 70

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.modify_cards([self], func(t): 
				return SharpnessModifier.new("sharpness_modifier"))\
		.enqueue()
