class_name ThrustCard
extends Card

var damage : int = 60
var status_turns = 2
var status_id = "vulnerable_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	var effect = DamageTakenAmplificationStatusEffect.new(status_id, 
		status_turns)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.apply_status(target, effect)
