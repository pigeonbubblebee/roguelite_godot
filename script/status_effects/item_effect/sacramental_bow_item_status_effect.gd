extends ItemStatusEffect

var damage : int = 20
var status_id: String = "blessing_status"
var armor : int = 10

func status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	if not ctx.actor == _owner:
		return
	if not ctx.status.get_status_id() == status_id:
		return
		
	var hit_actors = context.get_actors_of_faction(Faction.Type.ENEMY)
	var target = hit_actors.pick_random()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.damage(target, damage)\
		.armor(context.get_player(), armor)\
		.enqueue()
