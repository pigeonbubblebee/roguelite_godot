class_name BlessingStatusEffect
extends StatusEffect

var damage_percent_bonus := 0.1

func get_is_turn_based() -> bool:
	return false
# empowered by default
func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		context.add_damage_percent(damage_percent_bonus * _stacks)
