extends ItemStatusEffect

var status_buildup : int = 1
var status_id : String = "bleed_status"

func on_lose_life(actor: Actor, amount: int, context : BattleContext, controller : BattleController):
	if actor == _owner:
		var hit_actors = context.get_actors_of_faction(Faction.Type.ENEMY)
	
		EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.apply_status_multi(hit_actors, func(t): 
					return BleedStatusEffect.new(status_id, 
					context.get_player(), status_buildup))\
			.enqueue()
