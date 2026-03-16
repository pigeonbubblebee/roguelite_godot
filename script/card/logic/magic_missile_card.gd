class_name MagicMissileCard
extends Card

var damage : int = 45
var multistrike_amount : int = 3

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemys = context.get_selected_enemies_aoe()

	for i in range(multistrike_amount):
		var action = BattleRuntimeHelper.generate_basic_attack_action(context)
		
		var random_enemy = selected_enemys.pick_random()
		
		if random_enemy._processing_death:
			return
		
		action.append_action(PlayParticleEffectAction.new(random_enemy))
		
		controller.enqueue_action( action )
		
		var hit_actors: Array[Actor] = [ random_enemy ]
		
		var damage_context = BattleRuntimeHelper.generate_damage_context(damage, 
			hit_actors, context.get_player())
		damage_context.damage_type = DamageType.Type.MAGIC	
		damage_context.source_name = "magic_missile_card"
		damage_context.add_tag(DamageContext.TAG_CARD)
		
		controller.apply_damage(damage_context)
		
		if i == multistrike_amount - 1:
			continue
		
		await context.await_battle_actions()

func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
