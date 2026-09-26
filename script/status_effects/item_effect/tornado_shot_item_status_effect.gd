extends ItemStatusEffect

func before_damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if _context.damage_owner == _owner and _context.has_tag(DamageContext.TAG_FOLLOW_UP):
		_context.add_critical_chance(1.0)
