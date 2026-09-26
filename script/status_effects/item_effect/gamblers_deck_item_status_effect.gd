extends ItemStatusEffect

var damage = 10

func on_card_draw(card: Card, context: BattleContext, controller: BattleController):
	var hit_actors = context.get_actors_of_faction(Faction.Type.ENEMY)
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.multi_damage(hit_actors, damage, damage)\
		.enqueue()
