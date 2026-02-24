class_name PlayDeathAnimationAction
extends BattleVisualAction

var actor
var duration := 0.8

func _init(_actor, _duration := 0.8):
	actor = _actor
	duration = _duration

func execute(scene: BattleScene):
	var actor_ui = scene.request_ui_from_actor(actor)
	
	if not actor_ui:
		push_warning("No actor ui found for MoveForwardAction")
		finished.emit()
		return
	
	var tween = actor_ui.create_tween()
	tween.tween_property(actor_ui, "modulate:a", 0, duration)

	tween.finished.connect(func():
		finished.emit()
	)
