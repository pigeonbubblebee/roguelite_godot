class_name FocusCard
extends Card

var damage_percent_gain : float = 0.2

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
