class_name BlindRageCard
extends Card

var unsteady_turns : int = 2
var status_id_unsteady : String = "unsteady_status"
var rage_status_stacks : int = 12
var status_id_rage : String = "rage_status"

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var player = context.get_player()
	var unsteady_effect = ArmorAmplificationStatusEffect.new(status_id_unsteady, 
		unsteady_turns, ArmorAmplificationStatusEffect.unsteady_percent_bonus)
	var rage_effect = RageStatusEffect.new(status_id_rage, 
		rage_status_stacks)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.apply_status(player, unsteady_effect)\
		.apply_status(player, rage_effect)
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
