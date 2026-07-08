class_name MapScene
extends Node

@export var room_scene : PackedScene
@export var camera : Node2D
@export var horizontal_connector_scene : PackedScene
@export var vertical_connector_scene : PackedScene

var room_size : int = 32
var connector_size : int = 16
var left_corner = Vector2(-320, -180)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_A):
		camera.global_position.x -= 5 * delta * 60
	if Input.is_key_pressed(KEY_D):
		camera.global_position.x += 5 * delta * 60
	if Input.is_key_pressed(KEY_W):
		camera.global_position.y -= 5 * delta * 60
	if Input.is_key_pressed(KEY_S):
		camera.global_position.y += 5 * delta * 60

func render_map(map : Array):
	var nodes : Array[MapNode] = []
	for x in range(map.size()):
		for y in range(map[x].size()):
			if map[x][y]:
				nodes.append(map[x][y])
				var room_instance := room_scene.instantiate() as RoomScene
				add_child(room_instance)
				var pos = map[x][y].position
				room_instance.global_position = Vector2(
					pos.x * (room_size + connector_size), 
					pos.y * (room_size + connector_size)) + left_corner

	for node in nodes:
		for neighbor in node.neighbors:
			# Prevent duplicate connectors
			if node.position.x > neighbor.position.x:
				continue
			if node.position.y > neighbor.position.y:
				continue

			create_connector(node, neighbor)
func create_connector(a : MapNode, b : MapNode):
	var difference = b.position - a.position

	if difference.x != 0:
		# Horizontal connection
		var connector := horizontal_connector_scene.instantiate()

		var midpoint = (Vector2(a.position) + Vector2(b.position)) / 2

		connector.global_position = Vector2(
			midpoint.x * (room_size + connector_size),
			midpoint.y * (room_size + connector_size)
		) + left_corner

		add_child(connector)


	elif difference.y != 0:
		# Vertical connection
		var connector := vertical_connector_scene.instantiate()

		var midpoint = (Vector2(a.position) + Vector2(b.position)) / 2

		connector.global_position = Vector2(
			midpoint.x * (room_size + connector_size),
			midpoint.y * (room_size + connector_size)
		) + left_corner

		add_child(connector)
