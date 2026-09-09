class_name RitualStatusEffect
extends StatusEffect

var damage := 100
var vuln_percent : float = 0.02

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	#stacks_changed.connect(on_stacks_changed)

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	for actor in context.hit_actors:
		if actor.get_actor_faction() == _owner.get_actor_faction():
			continue
			
		var statuses = actor.get_status_manager().get_active_status()

		context.add_vulnerable(vuln_percent * _stacks, actor)
		
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		if _stacks > 20:
			var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
			
			EffectSequenceBuilder.new(battle_context, controller)\
				.as_status(self)\
				.use_action(custom_action)\
				.multi_damage(battle_context.get_actors_of_faction(Faction.Type.ENEMY), damage, 
					damage)\
				.enqueue()
				
			reduce_stacks(20)
				
func get_is_turn_based() -> bool:
	return false
