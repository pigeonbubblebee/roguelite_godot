class_name MapNode
extends RefCounted

var neighbors : Array[MapNode]
var position : Vector2
var branch = 0
var type : RoomType = RoomType.COMBAT

enum RoomType {
	COMBAT,
	START,
	ELITE,
	OCCASION,
	BOSS,
	KEY,
	TREASURE,
	SHOP,
	REST,
	EMPTY
}

func _to_string() -> String:
	match type:
		RoomType.START:
			return "S"
		RoomType.COMBAT:
			return "C"
		RoomType.BOSS:
			return "B"
		RoomType.ELITE:
			return "E"
		RoomType.OCCASION:
			return "?"
		RoomType.KEY:
			return "K"
		RoomType.TREASURE:
			return "T"
		RoomType.SHOP:
			return "$"
		RoomType.REST:
			return "R"
		RoomType.EMPTY:
			return ","
	return " "
	
func _init(_pos : Vector2, _type : RoomType = RoomType.COMBAT, _branch = "C") -> void:
	position = _pos
	type = _type
	branch = _branch
	
