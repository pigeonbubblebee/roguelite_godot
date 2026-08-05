class_name BashCard
extends Card

var damage : int = 50
var armor : int = 50
var status_id : String = "rage_status"
var status_stacks : int = 5

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	var player = context.get_player()
	var effect = RageStatusEffect.new(status_id, 
		status_stacks)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.armor(player, armor)\
		.apply_status(player, effect)
	
