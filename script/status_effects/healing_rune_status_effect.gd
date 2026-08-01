class_name HealingRuneStatusEffect
extends StatusEffect

func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)

func damage_dealt(context:DamageContext, b_context, controller):
	for actor in context.hit_actors:
		if actor == _owner:
			set_stacks(2)
	
func get_is_turn_based() -> bool:
	return false

func on_turn_start(_actor: Actor, battle_context: BattleContext, controller: BattleController):
	if not _actor == _owner:
		return
	
	if _stacks > 1:
		reduce_stacks()
	elif _stacks == 1:
		set_stacks(2)
		controller.heal_actor(_owner, 50)
