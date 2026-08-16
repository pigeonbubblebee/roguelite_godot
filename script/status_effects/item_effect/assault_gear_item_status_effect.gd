class_name AssaultGearStatusEffect
extends ItemStatusEffect

var damage_percent_bonus = 0.4
var triggered := false

func before_damage_dealt(_context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not _context.tags.has(DamageContext.TAG_CARD):
		return
	if _context.actor == _owner and not triggered:
		_context.add_damage_percent(damage_percent_bonus * _stacks)
		if not _context.is_preview:
			triggered = true
		
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_end(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
