class_name BurnStatusEffect
extends StatusEffect

var dot_damage

func _init(id: String, owner: Actor, _stacks: int = 1, _damage_per_stack: float = 0):
	super._init(id, owner, _stacks)
	
	dot_damage = _damage_per_stack
	
func get_is_turn_based() -> bool:
	return false

func on_turn_start(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return

	var hit_actors: Array[Actor] = [ actor ]
	
	var base_damage = dot_damage * get_stacks()
	
	var damage_context = BattleRuntimeHelper.generate_damage_context(base_damage, hit_actors, context.get_player(), 0, DamageType.Type.FIRE)	
	damage_context.source_name = "burn_status"
	
	var action = ParallelAction.new([
		PlayParticleEffectAction.new(actor),
		ShakeCameraAction.new(0.65)
	])

	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
	
	# Reduce Burn Stack by 1
	
	reduce_stacks()
