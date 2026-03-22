class_name BattleActionManager
extends Node

signal queue_started
signal queue_finished

var _action_queue: Array[BattleVisualAction] = []
var _is_processing_action := false

var _scene

var current_action

var _log_actions : bool = false

var _action_counter: int = 0


func bind(scene):
	_scene = scene
	#_context = context

func enqueue(action: BattleVisualAction) -> void:
	_insert_action_sorted(action)

	if not _is_processing_action:
		_process_next()
		
func _insert_action_sorted(action: BattleVisualAction) -> void:
	action._queue_order = _action_counter
	_action_counter += 1
	
	for i in range(_action_queue.size()):
		var other = _action_queue[i]
		
		if action.priority > other.priority \
		or (action.priority == other.priority and action._queue_order < other._queue_order):
			_action_queue.insert(i, action)
			return
	
	_action_queue.append(action)

func get_is_processing_action() -> bool:
	return _is_processing_action

func _process_next() -> void:
	if _action_queue.is_empty():
		_is_processing_action = false
		current_action = null
		queue_finished.emit()
		return

	if not _is_processing_action:
		_is_processing_action = true
		queue_started.emit()

	current_action = _action_queue.pop_front()
	current_action.finished.connect(_process_next)
	if _log_actions:
		print("BATTLE ACTION MANAGER: EXECUTING ACTION: " + str(current_action))
	current_action.execute(_scene)
