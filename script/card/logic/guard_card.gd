class_name GuardCard
extends Card

var armor : int = 50

func play(context: BattleContext, controller: BattleController):
	print("Armor Gained")
	super.play(context, controller)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
