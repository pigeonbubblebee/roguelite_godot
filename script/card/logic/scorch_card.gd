class_name ScorchCard
extends Card

var damage : int = 50
var status_buildup : int = 2
var status_id : String = "burn_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var hit_actors = context.get_selected_enemies_aoe()

	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player(), damage, DamageType.Type.FIRE)	
	damage_context.source_name = "scorch_card"
	damage_context.add_tag(DamageContext.TAG_CARD)
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	
	
	var all_dead = true

	for actor in hit_actors:
		if not actor._processing_death:
			all_dead = false
			action.append_action(PlayParticleEffectAction.new(actor))
	
	if all_dead:
		return
	
	controller.enqueue_action(action)
	
	for actor in hit_actors:
		var effect = BurnStatusEffect.new(status_id, actor, context.get_player(), status_buildup)

		var application_status = StatusEffectApplicationContext.new(actor, effect, context.get_player())
		controller.apply_status(application_status)
		action.append_action(PlayParticleEffectAction.new(actor))
	
	controller.apply_damage(damage_context)

func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
