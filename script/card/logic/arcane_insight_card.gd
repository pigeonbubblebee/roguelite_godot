class_name ArcaneInsightCard
extends Card

var damage_percent_gain : float = 0.3
var turns : int = 2
var status_id : String = "arcane_insight_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	var effect = DamageAmplificationEffect.new(status_id, 
		turns, damage_percent_gain)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.apply_status(player, effect)\
		.draw_card()\
		.enqueue()
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
