class_name DischargeCard
extends Card

var damage : int = 40
var stacks_storm : int = 3
var status_id_storm : String = "storm_status"

var stacks_discharge : int = 3
var status_id_discharge : String = "discharge_status"

var damage_type : DamageType.Type = DamageType.Type.LIGHTNING

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	var target = context.get_selected_enemy()
	var effect_storm = StormStatusEffect.new(
		status_id_storm, 
		context.event_bus, 
		stacks_storm)
	var effect_discharge = DischargeStatusEffect.new(
		status_id_discharge,
		stacks_discharge)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.apply_status(player, effect_storm)\
		.apply_status(player, effect_discharge)\
		.enqueue()
