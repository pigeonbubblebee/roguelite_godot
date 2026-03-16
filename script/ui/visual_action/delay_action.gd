class_name DelayAction
extends BattleVisualAction

var duration

func _init(_duration := 0.4):
	duration = _duration

func execute(scene: BattleScene):
	started.emit()
	await scene.get_tree().create_timer(duration).timeout
	finished.emit()
