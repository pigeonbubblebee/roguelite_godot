class_name DamageTakenAmplificationEffect
extends StatusEffect

var vuln_percent

func _init(id: String, _stacks: int = 1, _vuln_percent: float = 0):
	super._init(id, _stacks)
	
	vuln_percent = _vuln_percent

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	for actor in context.hit_actors:
		if actor == _owner:
			context.add_vulnerable(vuln_percent, _owner)
