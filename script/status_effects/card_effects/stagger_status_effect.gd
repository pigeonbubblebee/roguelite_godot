class_name StaggerStatusEffect
extends StatusEffect

var vuln_percent : float = 0.15
var weaken_percent : float = -0.1

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	for actor in context.hit_actors:
		if actor.get_actor_faction() == _owner.get_actor_faction():
			continue
			
		var statuses = actor.get_status_manager().get_active_status()
		
		for status in statuses:
			if status.get_status_id() == "daze_status":
				context.add_vulnerable(vuln_percent * _stacks, actor)
				
	
	if context.damage_owner.get_actor_faction() == _owner.get_actor_faction():
			return
			
	var statuses = context.damage_owner.get_status_manager().get_active_status()
	
	for status in statuses:
		if status.get_status_id() == "daze_status":
			context.add_damage_percent(weaken_percent  * _stacks)			

	
func get_is_turn_based() -> bool:
	return false
