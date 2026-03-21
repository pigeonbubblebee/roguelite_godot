class_name HeavySlashCard
extends Card

var damage : int = 80
var blast_damage : int = 40
var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var hit_actors = context.get_selected_enemies_blast()
	var custom_action = BattleRuntimeHelper.generate_heavy_attack_action(context)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.multi_damage(hit_actors, damage, 
			damage_type, blast_damage)\
		.enqueue()
	
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_blast(total_targets, target_index)
