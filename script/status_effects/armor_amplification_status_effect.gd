class_name ArmorAmplificationStatusEffect
extends StatusEffect

var armor_percent_bonus
static var sturdy_percent_bonus = 0.25
static var unsteady_percent_bonus = -0.25

# empowered by default
func _init(id: String, _stacks: int = 1, _armor_percent_bonus: float = unsteady_percent_bonus):
	super._init(id, _stacks)
	
	armor_percent_bonus = _armor_percent_bonus

func before_armor_applied(_context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	if _context.actor == _owner:
		_context.add_armor_percent(armor_percent_bonus)
