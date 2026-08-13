extends ItemStatusEffect

var triggered := false

func damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not context.damage_owner == _owner:
		return
	if (not context.hit_actors.size() == 1) or triggered:
		return
		
	triggered = true
		
	var faction = context.hit_actors[0].get_actor_faction()
	
	var hit_actors : Array[Actor] = []
	var damage : int = context.calculate_damage()[context.hit_actors[0]] / 2
	
	for actor in battle_context.get_actors_of_faction(faction):
		if not context.hit_actors.has(actor):
			hit_actors.append(actor)
			
	if hit_actors.size() == 0:
		print("return")
		return
			
	var custom_action = BattleRuntimeHelper.generate_basic_attack_action(battle_context)
	
	EffectSequenceBuilder.new(battle_context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.multi_damage(hit_actors, damage, damage)\
		.enqueue()
		
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_end(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
