class_name ConcussCard
extends Card

var status_buildup : int = 3
var status_id : String = "daze_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)

	var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.apply_status(target, effect)
