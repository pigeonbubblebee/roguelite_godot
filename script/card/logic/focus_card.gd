class_name FocusCard
extends Card

var damage_percent_gain : float = 0.5
var turns : int = 2
var status_id : String = "focus_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	
	
	controller.enqueue_action(BattleRuntimeHelper.generate_light_camera_shake_action())
	
	var effect = DamageAmplificationStatusEffect.new(status_id, player, 
		turns, damage_percent_gain)
	var application_status = StatusEffectApplicationContext.new(player, effect, context.get_player())
	controller.apply_status(application_status)
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
