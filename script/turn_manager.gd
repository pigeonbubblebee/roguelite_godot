class_name TurnManager
extends Node2D

# Note: AV -> Action Value, or time left until an actor's turn

# Auto sorted based on AV
var _active_actors: Array[Actor] = []

var _current_actor: Actor
signal active_actors_updated(actors: Array[Actor])

signal turn_started(actor: Actor)

func _input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_T:
		print("Debug: advancing turn!")
		progress_turn_order()
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_F:
		print("Debug: finishing turn!")
		finish_turn()

# Passes to the next turn
func progress_turn_order() -> void:
	if _active_actors.size() == 0:
		return
	
	# Access actor with least AV remaining to move
	_current_actor = _active_actors[0]
	var delta = _current_actor.get_remaining_av()
	
	for actor in _active_actors:
		actor.set_remaining_av(
			actor.get_remaining_av() - delta
		)
	
	active_actors_updated.emit(_active_actors)
	_current_actor.take_action()
	turn_started.emit(_current_actor)
	# EventBus.emit_signal("turn_start", _current_actor)

func finish_turn() -> void:
	reset_actor_av(_current_actor)
	_sort_actors()
	active_actors_updated.emit(_active_actors)
	
	await get_tree().create_timer(0.25).timeout
	progress_turn_order()
	
# Adds an actor to the turn order
# When adding actors, always sort the current actors afterwards
func add_actor(actor: Actor, context: BattleContext):
	reset_actor_av(actor)
	_active_actors.append(actor)
	actor.battle_context = context
	
	_sort_actors()
	active_actors_updated.emit(_active_actors)
	
# Sorts actors by remaining AV
func _sort_actors() -> void:
	_active_actors.sort_custom(func(a, b):
		return a.get_remaining_av() < b.get_remaining_av()
	)

# Resets an actor using their base AV
func reset_actor_av(actor: Actor) -> void:
	var base_av: float = calculate_base_av(actor)
	actor.set_remaining_av(base_av)

# Calculates an actor's base AV based on their speed
func calculate_base_av(actor: Actor) -> float:
	return 10000 / actor.get_speed()
	
func get_active_actors() -> Array:
	return _active_actors
	
func on_turn_end_button_pressed():
	finish_turn()
	
func remove_actor(actor: Actor):
	_active_actors.erase(actor)
	_sort_actors()
	
	active_actors_updated.emit(_active_actors)
