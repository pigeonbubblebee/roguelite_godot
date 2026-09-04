class_name BladedBlowCard
extends Card

var damage : int = 70
var crit_chance : float = 0.7

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, crit_chance)
