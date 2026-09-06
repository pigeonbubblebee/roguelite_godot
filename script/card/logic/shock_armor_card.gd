class_name ShockArmorCard
extends Card

var armor : int = 40
var stacks_storm : int = 2
var status_id_storm : String = "storm_status"

var stacks_discharge : int = 2
var status_id_discharge : String = "shock_armor_status"

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var player = context.get_player()

	var effect_storm = StormStatusEffect.new(
		status_id_storm, 
		context.event_bus, 
		stacks_storm)
	var effect_discharge = DischargeStatusEffect.new(
		status_id_discharge,
		stacks_discharge)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(BattleRuntimeHelper.generate_basic_defense_action(context, context.get_player()))\
		.armor(player, armor)\
		.apply_status(player, effect_storm)\
		.apply_status(player, effect_discharge)
