class_name FocusCard
extends Card

var damage_percent_gain : float = 0.5

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	
	var effect = DamageAmplificationStatusEffect.new("focus", player, 2, damage_percent_gain)
	controller.apply_status(player, effect)
	controller.enqueue_action(BattleRuntimeHelper.generate_light_camera_shake_action())
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
