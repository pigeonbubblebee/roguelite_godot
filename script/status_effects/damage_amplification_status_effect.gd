class_name DamageAmplificationStatusEffect
extends StatusEffect

var damage_percent_bonus
var empowered_percent_bonus = 0.5

# empowered by default
func _init(id: String, _stacks: int = 1, _damage_percent_bonus: float = empowered_percent_bonus):
	super._init(id, _stacks)
	
	damage_percent_bonus = _damage_percent_bonus

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		context.add_damage_percent(damage_percent_bonus)
