class_name ManaExplosionCard
extends Card

var damage : int = 150

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var hit_actors = context.get_selected_enemies_aoe(preview)
	var custom_action = BattleRuntimeHelper.generate_heavy_attack_action(context)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.multi_damage(hit_actors, damage, damage)
		
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
