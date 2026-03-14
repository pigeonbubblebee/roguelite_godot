class_name DazeStatusEffect
extends StatusEffect

var dot_damage : int = 2
var armor_reduction_percent : float = 0.025

func _init(id: String, owner: Actor, stacks: int = 1):
	super._init(id, owner, stacks)
	
func get_is_turn_based() -> bool:
	return false
	
func before_armor_applied(context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	if context.actor == _owner:
		var reduction_percent = -1 * armor_reduction_percent * get_stacks()
		context.add_armor_percent(reduction_percent)
		
func on_turn_end(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return

	var hit_actors: Array[Actor] = [ actor ]
	
	var base_damage = dot_damage * get_stacks()
	
	var damage_context = BattleRuntimeHelper.generate_damage_context(base_damage, hit_actors, context.get_player())	
	damage_context.source_name = "daze_status"
	
	var action = ParallelAction.new([
		PlayParticleEffectAction.new(actor),
		ShakeCameraAction.new(0.65)
	])

	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
	
	# Reduce Daze Stack by 1
	
	reduce_stacks()
