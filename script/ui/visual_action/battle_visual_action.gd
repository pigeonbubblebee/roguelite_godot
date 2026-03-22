class_name BattleVisualAction
extends RefCounted

signal started
signal finished

var priority: int = 0
var _queue_order : int = 0

func execute(scene: BattleScene):
	started.emit()
	finished.emit()
	
func set_priority(p: int) -> BattleVisualAction:
	priority = p
	return self
