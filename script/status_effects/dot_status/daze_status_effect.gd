class_name DazeStatusEffect
extends StatusEffect

var damage_owner
var dot_damage : int = 5
var weakened_percent_bonus = -0.20

func _init(id: String, _dmg_owner, stacks: int = 1):
	super._init(id, stacks)
	
	damage_owner = _dmg_owner

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		context.add_damage_percent(weakened_percent_bonus)

func get_is_turn_based() -> bool:
	return true

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
		.damage(target, base_damage)\
		.enqueue()
