class_name ActorWeightedMoveset
extends RefCounted

var _moves: Array = []
var _total_weight: float = 0.0

func add_move(move_instance: RefCounted, weight: float) -> void:
	if weight <= 0:
		weight = 0
	_moves.append({"move": move_instance, "weight": weight})
	_total_weight += weight

func get_weighted_move() -> RefCounted:
	if _moves.is_empty():
		push_error("WeightedMoveSet is empty!")
		return null

	var roll := randf() * _total_weight
	var cumulative := 0.0

	for entry in _moves:
		cumulative += entry.weight
		if roll <= cumulative:
			# Return a new copy of the selected move
			return entry.move.clone() # true = deep copy

	# Safety fallback
	return _moves[0].move.clone()
