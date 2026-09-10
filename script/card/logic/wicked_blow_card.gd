class_name WickedBlowCard
extends Card

var buildup : int = 8
var status_id : String = "ritual_status"
var damage := 80

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var player = context.get_player()
	var effect = RitualStatusEffect.new(status_id, 
		buildup)
	var target = context.get_selected_enemy(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.apply_status(player, effect)\
