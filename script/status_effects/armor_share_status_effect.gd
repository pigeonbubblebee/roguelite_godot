class_name ArmorShareStatusEffect
extends StatusEffect

# empowered by default
func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)

func armor_applied(_context: ArmorGainContext, battle_context: BattleContext, controller: BattleController):
	if _context.actor == _owner:
		var amt = _context.armor_gained
		
		var actors_of_faction = battle_context.get_actors_of_faction(_owner.get_actor_faction())
		for actor in actors_of_faction:
			if not actor == _owner:
				var custom_action = BattleRuntimeHelper.generate_basic_defense_action(battle_context)

				EffectSequenceBuilder.new(battle_context, controller)\
					.as_actor(actor)\
					.use_action(custom_action)\
					.armor(actor, amt)\
					.enqueue()

func get_is_turn_based() -> bool:
	return false
