class_name CorruptedStatusEffect
extends StatusEffect

static var armor_percent_debuff = -0.2
static var damage_percent_taken = 0.2

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	for actor in context.hit_actors:
		if actor == _owner:
			context.add_vulnerable(damage_percent_taken, _owner)

func before_armor_applied(_context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	if _context.actor == _owner:
		_context.add_armor_percent(armor_percent_debuff)
