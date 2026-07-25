class_name FlatDamageBonusStatusEffect
extends StatusEffect

var multiplier : int = 10 # might by default

func _init(id: String, _stacks: int = 1, _mult: float = 10):
	super._init(id, _stacks)

	multiplier = _mult

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		context.add_damage_flat(_stacks * multiplier)

func get_is_turn_based() -> bool:
	return false
