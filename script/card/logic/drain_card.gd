class_name DrainCard
extends Card

var status_buildup : int = 1
var status_id_1 := "vulnerable_status"
var status_id_2 := "weakened_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	var effect = DamageTakenAmplificationStatusEffect.new(status_id_1, status_buildup)
	var effect2 = DamageAmplificationStatusEffect.new(status_id_2, status_buildup, 
		DamageAmplificationStatusEffect.weakened_percent_bonus)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.apply_status(target, effect)\
		.apply_status(target, effect2)\
		.discard_card()
