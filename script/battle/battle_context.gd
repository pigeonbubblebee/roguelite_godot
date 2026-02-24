class_name BattleContext
extends RefCounted

var _turn_manager: TurnManager
var energy: int

signal hovered_actor_changed(actor: Actor)
signal selected_actor_changed(actor: Actor)

var hovered_enemy: Actor = null
var selected_actor: Actor = null

var selected_enemy_index: int

func _init(turn_manager: TurnManager):
	_turn_manager = turn_manager

func get_actors_of_faction(faction: Faction.Type) -> Array[Actor]:
	var active_actors = _turn_manager.get_active_actors()
	
	var result : Array[Actor] = []
	for actor in active_actors:
		if actor.get_actor_faction() == faction:
			result.append(actor)
	return result
	
func get_active_actors() -> Array[Actor]:
	return _turn_manager.get_active_actors()

func get_player() -> Actor:
	var active_actors = _turn_manager.get_active_actors()
	
	var result: Actor
	for actor in active_actors:
		if actor.get_actor_name() == "Player":
			result = actor
	return result
	
func get_current_energy() -> int:
	return energy

func set_hovered_actor(actor: Actor):
	if hovered_enemy == actor:
		return
	
	hovered_enemy = actor
	emit_signal("hovered_actor_changed", hovered_enemy)
	
func set_selected_actor(actor: Actor):
	selected_actor = actor
	emit_signal("selected_actor_changed", selected_actor)
	
func clear_hovered_actor():
	set_hovered_actor(null)
	
func on_energy_change(amt) -> void:
	energy = amt
	
# index 0 = center
func get_selected_enemies_blast() -> Array[Actor]:
	if not selected_actor:
		return []
		
	var enemies = get_actors_of_faction(Faction.Type.ENEMY)
	if enemies.size() == 0:
		return []
	
	var result: Array[Actor] = []
	var selected_pos = selected_actor.get_team_position()
	
	result.append(selected_actor)
	
	# Add the adjacent enemies if they exist
	for enemy in enemies:
		var pos = enemy.get_team_position()
		if pos == selected_pos - 1 or pos == selected_pos + 1:
			result.append(enemy)
	
	return result
	
# index 0 = selected
func get_selected_enemies_aoe() -> Array[Actor]:
	if not selected_actor:
		return []
		
	var enemies = get_actors_of_faction(Faction.Type.ENEMY)
	if enemies.size() == 0:
		return []
	
	var result: Array[Actor] = []
	# var selected_pos = selected_actor.get_team_position()
	
	result.append(selected_actor)
	
	# Add the adjacent enemies if they exist
	for enemy in enemies:
		if not enemy == selected_actor:
			result.append(enemy)
	
	return result

func get_selected_enemy() -> EnemyActor:
	return selected_actor

func get_hovered_enemy() -> EnemyActor:
	return hovered_enemy
