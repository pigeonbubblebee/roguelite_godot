extends ItemStatusEffect

var status_id: String = "daze_status"
var status_buildup : int = 2

func on_turn_start(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
		
	for status in actor.get_status_manager().get_active_status():
		if status.get_status_id() == "rage_status":
			var count = status.get_stacks()
			
			status.reduce_stacks(min(count, 4))
			
			if count >= 4:
				var hit_actors = context.get_actors_of_faction(Faction.Type.ENEMY)
				var target = hit_actors.pick_random()
				
				var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
				
				EffectSequenceBuilder.new(context, controller)\
					.as_status(self)\
					.apply_status(target, effect)\
					.enqueue()
