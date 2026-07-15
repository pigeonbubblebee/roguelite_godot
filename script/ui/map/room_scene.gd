class_name RoomScene
extends Node2D

var map_node : MapNode
@export var room_icon_path : NodePath
@onready var room_icon : Sprite2D = get_node(room_icon_path)
var icon_helper : RoomUIIconHelper = RoomUIIconHelper.new()

func update_map_node(node : MapNode):
	map_node = node
	
	room_icon.texture = icon_helper.icon_texture_map[node._to_string()]
