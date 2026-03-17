class_name ArcaneInsightCard
extends Card

var damage_percent_gain : float = 0.3
var turns : int = 2
var status_id : String = "arcane_insight_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	
	
	controller.enqueue_action(BattleRuntimeHelper.generate_light_camera_shake_action())
	
	var effect = DamageAmplificationEffect.new(status_id, 
		turns, damage_percent_gain)
	var application_status = StatusEffectApplicationContext.new(player, effect, context.get_player())
	controller.apply_status(application_status)
	
	controller.draw_card()
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
