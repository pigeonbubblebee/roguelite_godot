class_name DeepImpactCard
extends Card

var status_buildup : int = 2
var additional_status_buildup : int = 2
var status_id : String = "daze_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	var amt = status_buildup
	
	for s in target.get_status_manager().get_active_status():
		if s.id == "daze_status":
			amt += additional_status_buildup

	var effect = DazeStatusEffect.new(status_id, context.get_player(), amt)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.apply_status(target, effect)
