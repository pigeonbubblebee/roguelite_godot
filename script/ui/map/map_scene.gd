class_name MapScene
extends Node

@export var room_scene : PackedScene
@export var player_icon : Node2D
@export var horizontal_connector_scene : PackedScene
@export var vertical_connector_scene : PackedScene

var room_size_h : int = 56 #-8 to accont for border, so connector can make transition seamless
var room_size_v : int = 40
var connector_size : int = 16
var left_corner = Vector2(-320, -180)

var map_nodes : Array[RoomScene]

func _process(delta: float) -> void:
	pass
	
func bind_controller(controller: MapController):
	render_map(controller.map)
	controller.player_moved.connect(move_player_to)
	
func move_player_to(node: MapNode):
	for room in map_nodes:
		if room.map_node == node:
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_IN_OUT)

			tween.tween_property(
				player_icon,
				"global_position",
				room.global_position,
				0.2
			)

			return
	
func render_map(map : Array):
	var nodes : Array[MapNode] = []
	var start_node : RoomScene
	
	for x in range(map.size()):
		for y in range(map[x].size()):
			if map[x][y]:
				nodes.append(map[x][y])
				var room_instance := room_scene.instantiate() as RoomScene
				add_child(room_instance)
				room_instance.update_map_node(map[x][y])
				map_nodes.append(room_instance)
				
				if map[x][y].type == MapNode.RoomType.START:
					start_node = room_instance
				
				var pos = map[x][y].position
				room_instance.global_position = Vector2(
					pos.x * (room_size_h + connector_size), 
					pos.y * (room_size_v + connector_size)) + left_corner

	for node in nodes:
		for neighbor in node.neighbors:
			# Prevent duplicate connectors
			if node.position.x > neighbor.position.x:
				continue
			if node.position.y > neighbor.position.y:
				continue

			create_connector(node, neighbor)
	
	if start_node:
		player_icon.global_position = start_node.global_position
			
func create_connector(a : MapNode, b : MapNode):
	var difference = b.position - a.position

	if difference.x != 0:
		# Horizontal connection
		var connector := horizontal_connector_scene.instantiate()

		var midpoint = (Vector2(a.position) + Vector2(b.position)) / 2

		connector.global_position = Vector2(
			midpoint.x * (room_size_h + connector_size),
			midpoint.y * (room_size_v + connector_size)
		) + left_corner

		add_child(connector)

	elif difference.y != 0:
		# Vertical connection
		var connector := vertical_connector_scene.instantiate()

		var midpoint = (Vector2(a.position) + Vector2(b.position)) / 2

		connector.global_position = Vector2(
			midpoint.x * (room_size_h + connector_size),
			midpoint.y * (room_size_v + connector_size)
		) + left_corner

		add_child(connector)
