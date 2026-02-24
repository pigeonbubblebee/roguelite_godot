class_name BattleVisualAction
extends RefCounted

signal finished

func execute(scene: BattleScene):
	finished.emit()
