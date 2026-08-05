class_name HeavyAxeCard
extends Card

var stacks : int = 1
var status_id : String = "heavy_axe_status"
static var DAZE_AMOUNT : int = 2
var rage_status_id : String = "rage_status"
var rage_stacks : int = 5

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var player = context.get_player()
	var effect = HeavyAxeStatusEffect.new(status_id, 
		stacks)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.apply_status(player, RageStatusEffect.new(rage_status_id, rage_stacks))\
		.apply_status(player, effect)
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
