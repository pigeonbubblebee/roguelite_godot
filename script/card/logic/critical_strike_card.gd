class_name CriticalStrikeCard
extends Card

var damage : int = 60

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	var sharpen = 0
	
	for status in target.get_status_manager().get_active_status():
		if status.get_status_id() == "daze_status":
			sharpen = status.get_stacks()
	
	var seq = EffectSequenceBuilder.new(context, controller)\
		.as_card(self)		
	if sharpen > 0:
		seq = seq.modify_cards([self], func(t): return SharpnessModifier.new("sharpness_modifier", sharpen))
	
	return seq.damage(target, damage)
