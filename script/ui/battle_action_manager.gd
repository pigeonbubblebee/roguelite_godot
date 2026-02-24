class_name BattleActionManager
extends Node

signal queue_started
signal queue_finished

var _action_queue: Array[BattleVisualAction] = []
var _is_processing_action := false

var _scene

var current_action

var _log_actions : bool = false

func bind(scene):
	_scene = scene
	#_context = context

func enqueue(action: BattleVisualAction) -> void:
	_action_queue.append(action)

	if not _is_processing_action:
		_process_next()

func get_is_processing_action() -> bool:
	return _is_processing_action

func _process_next() -> void:
	if _action_queue.is_empty():
		_is_processing_action = false
		queue_finished.emit()
		current_action = null
		return

	if not _is_processing_action:
		_is_processing_action = true
		queue_started.emit()

	current_action = _action_queue.pop_front()
	current_action.finished.connect(_process_next)
	if _log_actions:
		print("BATTLE ACTION MANAGER: EXECUTING ACTION: " + str(current_action))
	current_action.execute(_scene)
