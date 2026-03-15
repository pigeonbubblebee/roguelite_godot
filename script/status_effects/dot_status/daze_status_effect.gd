class_name DazeStatusEffect
extends StatusEffect

var damage_owner

var dot_damage : int = 2
var armor_reduction_percent : float = 0.025

func _init(id: String, owner: Actor, _dmg_owner, stacks: int = 1):
	super._init(id, owner, stacks)
	
	damage_owner = _dmg_owner
	
func get_is_turn_based() -> bool:
	return false
	
func before_armor_applied(context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	if context.actor == _owner:
		var reduction_percent = -1 * armor_reduction_percent * get_stacks()
		context.add_armor_percent(reduction_percent)
		
func on_turn_start(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
		
	if actor._processing_death:
		return

	var hit_actors: Array[Actor] = [ actor ]
	
	var base_damage = dot_damage * get_stacks()
	
	var damage_context = BattleRuntimeHelper.generate_damage_context(base_damage, 
		hit_actors, damage_owner)	
	damage_context.source_name = "daze_status"
	
	var action = ParallelAction.new([
		PlayParticleEffectAction.new(actor),
		ShakeCameraAction.new(0.65)
	])
	
	action.started.connect(func():
		controller.apply_damage(damage_context)
	)

	controller.enqueue_action(action)
	
	# Reduce Daze Stack by 1
	
func on_turn_end(actor: Actor, context: BattleContext, controller: BattleController):
	if actor == _owner:
		reduce_stacks()
