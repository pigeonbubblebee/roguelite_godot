class_name MagicMissileCard
extends Card

var damage : int = 45
var multistrike_amount : int = 3

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemys = context.get_selected_enemies_aoe()
	
	var actions : Array[BattleVisualAction] = []
	var random_enemies : Array[Actor] = []
	
	for i in range(multistrike_amount):
		var action = BattleRuntimeHelper.generate_basic_attack_action(context)
		actions.append(action)
		
		var random_enemy = selected_enemys.pick_random()
		random_enemies.append(random_enemy)
		
		action.append_action(PlayParticleEffectAction.new(random_enemy, "magic_slash"))
		
		controller.enqueue_action( action )
		
	
	for i in range(multistrike_amount):
		var hit_actors: Array[Actor] = [ random_enemies[i] ]
		
		var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, 0, DamageType.Type.MAGIC)	
		damage_context.source_name = "magic_missile_card"
		
		controller.apply_damage(damage_context)
		
		if i == multistrike_amount - 1:
			continue
		
		await actions[i].finished

func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
