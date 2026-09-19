extends ItemStatusEffect

var damage = 200
var coreflames = 0

func status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	var status = ctx.status
	
	if not status.get_is_visible():
		return
		
	if status.status_type == StatusEffect.TYPE_BUFF:
		coreflames += 1
		
		if coreflames >= 12:
			coreflames = 0
			
			var hit_actors = context.get_actors_of_faction(Faction.Type.ENEMY)
			EffectSequenceBuilder.new(context, controller)\
				.as_status(self)\
				.multi_damage(hit_actors, damage, damage)\
				.enqueue()
