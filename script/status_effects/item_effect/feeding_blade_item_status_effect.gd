extends ItemStatusEffect

var status_id := "bleed_status"
var status_buildup := 1

func on_turn_start(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
		
	for status in actor.get_status_manager().get_active_status():
		if status.get_status_id() == "ritual_status":
			var count = min(status.get_stacks(), 6)
			
			status.reduce_stacks(min(count, 6))
			
			var bleed = ceil(count / 2)
			var hit_actors = battle_context.get_actors_of_faction(Faction.Type.ENEMY)
			var dict : Dictionary = {}
			
			for t in hit_actors:
				dict[t] = 0
			
			#print(bleed)
			
			for i in bleed:
				var target = hit_actors.pick_random()
				if dict.has(target):
					dict[target] += status_buildup
				
			EffectSequenceBuilder.new(battle_context, controller)\
				.as_status(self)\
				.apply_status_multi(hit_actors,  func(t): 
					return BleedStatusEffect.new(status_id, 
					battle_context.get_player(), dict[t]))\
				.enqueue()
