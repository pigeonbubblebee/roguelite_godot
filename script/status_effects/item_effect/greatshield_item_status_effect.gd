extends ItemStatusEffect

var armor_percent_bonus := 0.15

func before_armor_applied(_context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	if _context.actor == _owner:
		_context.add_armor_percent(armor_percent_bonus)
