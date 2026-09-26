extends ItemStatusEffect

var stacks = 0
var damage = 10

func energy_used(current: int, amount: int, context: BattleContext, controller: BattleController):
	stacks += amount

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		var selected_enemys = battle_context.get_actors_of_faction(Faction.Type.ENEMY)
		
		var target = selected_enemys.pick_random()
		
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)\
			.damage(target, damage * stacks)\
			.enqueue()
			
		stacks = 0
