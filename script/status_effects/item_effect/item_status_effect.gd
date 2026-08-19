class_name ItemStatusEffect
extends StatusEffect

func get_is_turn_based() -> bool:
	return false
	
func get_is_visible() -> bool:
	return false

func on_battle_start(context: BattleContext, controller:BattleController):
	pass
