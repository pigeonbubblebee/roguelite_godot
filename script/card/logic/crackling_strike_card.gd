class_name CracklingStrikeCard
extends Card

var damage : int = 80

var is_discarded = false

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	print(is_discarded)
	
	if is_discarded:
		selected_enemy = context.get_actors_of_faction(Faction.Type.ENEMY).pick_random()
	
	if selected_enemy._processing_death:
		return
	
	var hit_actors: Array[Actor] = [ selected_enemy ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
	damage_context.source_name = "crackling_strike_card"
	damage_context.damage_type = DamageType.Type.LIGHTNING
	damage_context.add_tag(DamageContext.TAG_CARD)
	
	var action = BattleRuntimeHelper.generate_heavy_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(selected_enemy))
	
	action.started.connect(func():
		controller.apply_damage(damage_context)
	)
	
	controller.enqueue_action(action)
	
	

func on_discard(context: BattleContext, controller: BattleController):
	super.on_discard(context, controller)
	
	is_discarded = true
	
	var fua = CardPlayFollowUp.new(play, self.id)
	
	fua.execute(context, controller)	
