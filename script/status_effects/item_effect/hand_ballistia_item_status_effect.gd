extends ItemStatusEffect

var damage = 10
var amount = 3

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		var selected_enemys = battle_context.get_actors_of_faction(Faction.Type.ENEMY)
		
		var sequence = EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)
			
		for i in range(amount):
			var target = selected_enemys.pick_random()
			sequence.damage(target, damage)
			
			if i < amount - 1:
				sequence.delay()
				
		sequence.enqueue()
