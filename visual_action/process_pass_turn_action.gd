class_name ProcessPassTurnAction
extends BattleVisualAction

var duration := 0.4

func _init(_duration := 0.4):
	duration = _duration

func execute(scene: BattleScene):
	await scene.get_tree().create_timer(duration).timeout
	finished.emit()
