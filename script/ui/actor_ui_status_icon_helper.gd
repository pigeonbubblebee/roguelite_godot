class_name ActorUIStatusIconHelper

var damage_percent_buff_icon = preload("res://assets/ui/status_icons/damage_percent_buff_icon.png")

var status_icon_scene : PackedScene = preload("res://scenes/status_label.tscn")

var status_texture_map: Dictionary = {
	"damage_percent_buff": damage_percent_buff_icon
}
