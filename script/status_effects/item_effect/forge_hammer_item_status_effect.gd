extends ItemStatusEffect

var damage : int = 40
var status_id: String = "daze_status"
var status_buildup : int = 1

func modifier_applied(card: Card, mod: CardModifier, context: BattleContext, controller: BattleController):
	if not mod.id == "sharpness_modifier":
		return
		
	var hit_actors = context.get_actors_of_faction(Faction.Type.ENEMY)
	var target = hit_actors.pick_random()
	
	var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.damage(target, damage)\
		.apply_status(target, effect)\
		.enqueue()
