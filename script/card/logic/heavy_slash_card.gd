class_name HeavySlashCard
extends Card

var damage : int = 80
var blast_damage : int = 40

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var hit_actors = context.get_selected_enemies_blast()
	var damage_context = CardRuntimeHelper.generate_damage_context(damage, hit_actors, blast_damage)	
	damage_context.source_name = "heavy_slash_card"
	
	var action = CardRuntimeHelper.generate_heavy_attack_action(context)
	for actor in hit_actors:
		action.append_action(PlayParticleEffectAction.new(actor))
	
	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
	
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_blast(total_targets, target_index)
