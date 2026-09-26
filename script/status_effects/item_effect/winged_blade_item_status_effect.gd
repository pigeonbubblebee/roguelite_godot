extends ItemStatusEffect

var armor : int = 30
var stacks_storm : int = 1
var status_id_storm : String = "storm_status"

var stacks_discharge : int = 1
var status_id_discharge : String = "temporary_storm_status"

func on_card_discarded(card : Card, context: BattleContext, controller: BattleController):
	var player = context.get_player()

	var effect_storm = StormStatusEffect.new(
		status_id_storm, 
		context.event_bus, 
		stacks_storm)
	var effect_discharge = DischargeStatusEffect.new(
		status_id_discharge,
		stacks_discharge)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(BattleRuntimeHelper.generate_basic_defense_action(context, context.get_player()))\
		.armor(player, armor)\
		.apply_status(player, effect_storm)\
		.apply_status(player, effect_discharge)\
		.enqueue()
