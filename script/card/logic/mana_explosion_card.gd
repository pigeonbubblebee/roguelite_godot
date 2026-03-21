class_name ManaExplosionCard
extends Card

var damage : int = 210
var damage_type : DamageType.Type = DamageType.Type.MAGIC

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var hit_actors = context.get_selected_enemies_aoe()
	var custom_action = BattleRuntimeHelper.generate_heavy_attack_action(context)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.multi_damage(hit_actors, damage, 
			damage_type, damage)\
		.enqueue()

func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
