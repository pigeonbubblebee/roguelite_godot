class_name DamageAmplificationStatusEffect
extends StatusEffect

var damage_percent_bonus

func _init(id: String, owner: Actor, _stacks: int = 1, _damage_percent_bonus: float = 0):
	super._init(id, owner, _stacks)
	
	damage_percent_bonus = _damage_percent_bonus

func get_name():
	push_error("StatusEffect.get_name() must be implemented by subclass")
	return "Unnamed Status"

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		context.add_damage_percent(damage_percent_bonus)
