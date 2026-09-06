class_name DischargeCard
extends Card

var damage : int = 50
var stacks_storm : int = 3
var status_id_storm : String = "storm_status"

var stacks_discharge : int = 3
var status_id_discharge : String = "discharge_status"

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var player = context.get_player()
	var target = context.get_selected_enemy()
	var effect_storm = StormStatusEffect.new(
		status_id_storm, 
		context.event_bus, 
		stacks_storm)
	var effect_discharge = DischargeStatusEffect.new(
		status_id_discharge,
		stacks_discharge)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.apply_status(player, effect_storm)\
		.apply_status(player, effect_discharge)
