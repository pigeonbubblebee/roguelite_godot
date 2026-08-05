class_name HardenedBladesStatusEffect
extends StatusEffect

func before_modifier_applied(card: Card, mod: CardModifier, context: BattleContext, controller: BattleController):
	if mod.id == "sharpness_modifier":
		mod.stacks += 1*_stacks
	
func get_is_turn_based() -> bool:
	return false
