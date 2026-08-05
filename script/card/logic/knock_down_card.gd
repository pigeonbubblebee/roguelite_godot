class_name KnockDownCard
extends Card

var status_buildup : int = 2
var status_id : String = "daze_status"
var armor: int = 130

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)

	var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.armor(context.get_player(), armor)\
		.apply_status(target, effect)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
