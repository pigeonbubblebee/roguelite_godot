class_name SharpnessModifier
extends CardModifier

var damage_amp = 0.07

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.source == _owner:
		context.add_damage_percent(damage_amp * stacks)

func get_name():
	return "Sharpened"
