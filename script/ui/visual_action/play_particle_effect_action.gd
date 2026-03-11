class_name PlayParticleEffectAction
extends BattleVisualAction

var effect_name: String
var target_actor: Actor  # Actor to attach effect to

func _init(actor, name = "slash"):
	target_actor = actor
	effect_name = name

func execute(scene: Node):
	var actor_ui = scene.request_ui_from_actor(target_actor)
	
	if not actor_ui:
		push_warning("No actor ui found for PlayParticleEffectAction")
		finished.emit()
		return
		
	var particle = scene.particle_effect_helper.spawn_effect(effect_name, 
		actor_ui, actor_ui.global_position)
		
	if not particle:
		emit_signal("finished")
		return

	particle.finished.connect(_on_particle_finished)
	particle.restart()

func _on_particle_finished():
	emit_signal("finished")
