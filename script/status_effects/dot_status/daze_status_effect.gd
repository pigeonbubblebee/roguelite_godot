class_name DazeStatusEffect
extends StatusEffect

var damage_owner

var dot_damage : int = 2
var armor_reduction_percent : float = 0.025

var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func _init(id: String, _dmg_owner, stacks: int = 1):
	super._init(id, stacks)
	
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
	
func on_turn_end(actor: Actor, context: BattleContext, controller: BattleController):
	if actor == _owner:
		reduce_stacks()
