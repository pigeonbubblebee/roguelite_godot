class_name SunderingStrikeCard
extends Card

var damage : int = 70
var status_buildup : int = 2
var status_id : String = "daze_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)

	var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.apply_status(target, effect)
