class_name BloodWriting
extends Card

var buildup : int = 6
var status_id : String = "ritual_status"

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var player = context.get_player()
	var effect = RitualStatusEffect.new(status_id, 
		buildup)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.draw_card(2)\
		.apply_status(player, effect)\
		.lose_life(player, 20)
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
