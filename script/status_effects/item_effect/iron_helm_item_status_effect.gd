class_name IronHelmStatusEffect
extends ItemStatusEffect

var armor_percent_bonus = 0.2
var triggered := false

# empowered by default
func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)

func before_armor_applied(_context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	if _context.actor == _owner and not triggered:
		_context.add_armor_percent(armor_percent_bonus * _stacks)
		if not _context.is_preview:
			triggered = true
		
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_end(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
