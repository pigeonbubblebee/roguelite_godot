class_name ScreechCard
extends Card

var status_buildup : int = 1
var status_id : String = "weakened_status"
var armor: int = 70

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)

	var effect = DamageAmplificationStatusEffect.new(status_id, status_buildup, 
		DamageAmplificationStatusEffect.weakened_percent_bonus)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.armor(context.get_player(), armor)\
		.apply_status(target, effect)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
