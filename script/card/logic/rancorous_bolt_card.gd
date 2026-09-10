class_name RancorousBoltCard
extends Card

var damage : int = 130
var status_turns : int = 2
var status_id : String = "vulnerable_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy()
	var effect = DamageTakenAmplificationStatusEffect.new(status_id, 
		status_turns)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.apply_status(target, effect)
