class_name ActorCycleMoveset
extends RefCounted

var _moves: Array = []
var current_index = 0

var first_move
var used_first_move = false

func add_move(move_instance: RefCounted) -> void:
	_moves.append(move_instance)

func add_first_move(move_instance: RefCounted) -> void:
	first_move = move_instance

func randomize_index():
	current_index = randi_range(0, _moves.size() - 1)

func get_next_move() -> RefCounted:
	if first_move:
		if not used_first_move:
			used_first_move = true
			return first_move	

	if _moves.is_empty():
		push_error("CycleMoveset is empty!")
		return null
	var result = _moves[current_index].clone()
	
	if current_index == _moves.size() - 1:
		current_index = 0
	else:
		current_index += 1
	
	return result
