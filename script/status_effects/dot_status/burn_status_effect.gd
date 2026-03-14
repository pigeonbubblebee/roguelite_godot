class_name BurnStatusEffect
extends StatusEffect

var damage_owner
var dot_damage : int = 10

func _init(id: String, owner: Actor, _dmg_owner, stacks: int = 1):
	super._init(id, owner, stacks)
	
	damage_owner = _dmg_owner
	
func get_is_turn_based() -> bool:
	return false

func on_turn_start(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return

	var hit_actors: Array[Actor] = [ actor ]
	
	var base_damage = dot_damage * get_stacks()
	
	# TBD: Add inflictor field
	var damage_context = BattleRuntimeHelper.generate_damage_context(base_damage, 
		hit_actors, damage_owner)	
	damage_context.damage_type = DamageType.Type.FIRE
	damage_context.source_name = "burn_status"
	
	var action = ParallelAction.new([
		PlayParticleEffectAction.new(actor),
		ShakeCameraAction.new(0.65)
	])

	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
	
	# Reduce Burn Stack by 1
	
	reduce_stacks()
