class_name MoveForwardAction
extends BattleVisualAction

var actor
var distance := 40
var duration := 0.12

func _init(_actor, _distance := 40, _duration := 0.12):
	actor = _actor
	distance = _distance
	duration = _duration

func execute(scene: BattleScene):
	var actor_ui = scene.request_ui_from_actor(actor)
	
	if not actor_ui:
		push_warning("No actor ui found for MoveForwardAction")
		finished.emit()
		return
		
	var original_pos = actor_ui.global_position
	var forward_pos = original_pos + Vector2(distance, 0)

	var tween = actor_ui.create_tween()
	tween.tween_property(actor_ui, "global_position", forward_pos, duration)
	tween.tween_property(actor_ui, "global_position", original_pos, duration)


	tween.finished.connect(func():
		finished.emit()
	)
