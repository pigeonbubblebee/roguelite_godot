class_name CardSelectionAction
extends BattleVisualAction

func _init(ctx):
	pass

func execute(scene: BattleScene):
	started.emit()
	print("selecting")
	await scene.get_tree().create_timer(0.2).timeout
	finished.emit()
