class_name StaggerCard
extends Card

var stacks : int = 1
var status_id : String = "stagger_status"

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var player = context.get_player()
	var effect = StaggerStatusEffect.new(status_id, 
		stacks)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.apply_status(player, effect)
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
