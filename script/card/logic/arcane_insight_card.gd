class_name ArcaneInsightCard
extends Card

var damage_percent_gain : float = -0.3
var turns : int = 1
var status_id : String = "arcane_insight_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	var hit_actors = context.get_selected_enemies_aoe()
	var effect = DamageAmplificationStatusEffect.new(status_id, 
		turns, damage_percent_gain)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.apply_status_multi(hit_actors, func(t): 
			return DamageAmplificationStatusEffect.new(status_id, 
			turns, damage_percent_gain))\
		.draw_card()\
		.enqueue()
	
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
