extends ItemStatusEffect

var vuln_percent : float = 0.25

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	for actor in context.hit_actors:
		if actor.get_actor_faction() == _owner.get_actor_faction():
			continue
			
		var statuses = actor.get_status_manager().get_active_status()
		
		for status in statuses:
			if status.get_status_id() == "daze_status":
				context.add_vulnerable(vuln_percent * _stacks, actor)
	
func get_is_turn_based() -> bool:
	return false
