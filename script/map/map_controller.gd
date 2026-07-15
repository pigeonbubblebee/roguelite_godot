class_name MapController
extends Node

var map : Array
var current_node : MapNode

signal player_moved(node)
signal map_visibility_updated()

func get_neighbor(direction: Vector2) -> MapNode:
	for neighbor in current_node.neighbors:
		if neighbor.position - current_node.position == direction:
			return neighbor

	return null
	
func move(direction: Vector2i):
	var next := get_neighbor(direction)

	if next == null:
		return

	current_node = next
	
	update_visibility()

	player_moved.emit(next)

func update_visibility():
	for column in map:
		for node in column:
			if node:
				node.visible = false

	current_node.discovered = true

	for column in map:
		for node in column:
			if node and node.discovered:
				node.visible = true

				for neighbor in node.neighbors:
					neighbor.visible = true

	map_visibility_updated.emit()

func load_map(_map : Array):
	map = _map
	
	for column in map:
		for node in column:
			if node and node.type == MapNode.RoomType.START:
				current_node = node
				update_visibility()
				return

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		move(Vector2i.RIGHT)

	elif Input.is_action_just_pressed("ui_left"):
		move(Vector2i.LEFT)

	elif Input.is_action_just_pressed("ui_up"):
		move(Vector2i.UP)

	elif Input.is_action_just_pressed("ui_down"):
		move(Vector2i.DOWN)
