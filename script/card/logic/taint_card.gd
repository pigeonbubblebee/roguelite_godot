class_name TaintCard
extends Card

var status_buildup : int = 2
var status_id : String = "corrupted_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	var effect = CorruptedStatusEffect.new(status_id, status_buildup)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.apply_status(target, effect)\
		.lose_life(context.get_player(), 10)
