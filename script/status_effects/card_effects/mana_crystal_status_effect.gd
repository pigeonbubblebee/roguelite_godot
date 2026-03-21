class_name ManaCrystalStatusEffect
extends StatusEffect

func _init(id: String, stacks: int = 1):
	super._init(id, stacks)
	
func get_is_turn_based() -> bool:
	return false
		
func on_turn_start(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
		
	controller.gain_energy(get_stacks())

	reduce_stacks(get_stacks())
