extends ItemStatusEffect

func resolve_damage(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not _context.damage_owner == _owner:
		return
		
	if _context.critical_chance > 1.0:
		var excess = _context.critical_chance - 1.0
		
		_context.add_damage_percent(excess)
