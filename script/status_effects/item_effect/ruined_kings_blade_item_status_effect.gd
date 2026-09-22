extends ItemStatusEffect

var percent_hp = 0.05
var max_flat_bonus = 100

func before_damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not _context.damage_owner == _owner:
		return
		
	for target in _context.hit_actors:
		var bonus_flat = min(max_flat_bonus, ceil(percent_hp * target.get_max_health()))
		
		_context.add_damage_flat_to_target(bonus_flat, target)
