class_name RoomUIIconHelper

var combat_icon = preload("res://assets/ui/map/room_icons/combat_icon.png")
var empty_icon = preload("res://assets/ui/map/room_icons/empty_icon.png")
var boss_icon = preload("res://assets/ui/map/room_icons/boss_icon.png")
var rest_icon = preload("res://assets/ui/map/room_icons/rest_icon.png")
var treasure_icon = preload("res://assets/ui/map/room_icons/treasure_icon.png")
var shop_icon = preload("res://assets/ui/map/room_icons/shop_icon.png")
var elite_icon = preload("res://assets/ui/map/room_icons/elite_icon.png")
var occasion_icon = preload("res://assets/ui/map/room_icons/occasion_icon.png")

# Registry for status textures
var icon_texture_map: Dictionary = {
	"C": combat_icon,
	"S": empty_icon,
	",": empty_icon,
	"B": boss_icon,
	"R": rest_icon,
	"T": treasure_icon,
	"$": shop_icon,
	"E": elite_icon,
	"K": combat_icon,
	"?": occasion_icon
}
