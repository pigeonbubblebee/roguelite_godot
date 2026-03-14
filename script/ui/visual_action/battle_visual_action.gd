class_name BattleVisualAction
extends RefCounted

signal started
signal finished

func execute(scene: BattleScene):
	started.emit()
	finished.emit()
