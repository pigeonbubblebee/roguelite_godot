class_name DefiantBlowCard
extends Card

var status_stacks : int = 2
var status_id : String = "resolve_status"
var damage : int = 80

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	var player = context.get_player()
	var effect = ResolveStatusEffect.new(status_id, 
		status_stacks)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.apply_status(player, effect)
