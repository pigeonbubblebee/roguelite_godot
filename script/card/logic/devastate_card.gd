class_name DevastateCard
extends Card

var damage : int = 200
var armor : int = 200

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	var player = context.get_player()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.armor(context.get_player(), armor)
	
