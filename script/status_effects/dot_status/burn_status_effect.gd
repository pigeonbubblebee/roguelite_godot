class_name BurnStatusEffect
extends StatusEffect

var damage_owner
var dot_damage : int = 10

var damage_type : DamageType.Type = DamageType.Type.FIRE

func _init(id: String, _dmg_owner, stacks: int = 1):
	super._init(id, stacks)
	
	damage_owner = _dmg_owner
	
func get_is_turn_based() -> bool:
	return false

func on_turn_start(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
		
	var target = actor
	var base_damage = dot_damage * get_stacks()
	var custom_action = ParallelAction.new([
		PlayParticleEffectAction.new(actor),
		ShakeCameraAction.new(0.65)
	])
	
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.damage(target, base_damage, damage_type)\
		.enqueue()
	
	# Reduce Burn Stack by 1
	
	reduce_stacks()
