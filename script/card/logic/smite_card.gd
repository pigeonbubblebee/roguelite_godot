class_name SmiteCard
extends Card

var damage : int = 130

func get_takes_max_hand_space() -> bool:
	return false

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)
