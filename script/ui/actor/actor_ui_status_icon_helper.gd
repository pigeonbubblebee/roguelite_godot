class_name ActorUIStatusIconHelper

var burn_debuff_icon = preload("res://assets/ui/status_icons/burn_debuff_icon.png")
var damage_percent_buff_icon = preload("res://assets/ui/status_icons/damage_percent_buff_icon.png")
var damage_percent_debuff_icon = preload("res://assets/ui/status_icons/damage_percent_debuff_icon.png")
var follow_up_buff_icon = preload("res://assets/ui/status_icons/follow_up_buff_icon.png")
var storm_buff_icon = preload("res://assets/ui/status_icons/storm_buff_icon.png")
var daze_debuff_icon = preload("res://assets/ui/status_icons/daze_debuff_icon.png")
var mana_crystal_buff_icon = preload("res://assets/ui/status_icons/mana_crystal_buff_icon.png")
var damage_taken_percent_debuff_icon = preload("res://assets/ui/status_icons/damage_taken_percent_debuff_icon.png")
var fortitude_buff_icon = preload("res://assets/ui/status_icons/fortitude_buff_icon.png")

var status_icon_scene : PackedScene = preload("res://scenes/status_label.tscn")

# Registry for status textures
var status_texture_map: Dictionary = {
	"burn_debuff": burn_debuff_icon,
	"damage_percent_buff": damage_percent_buff_icon,
	"damage_percent_debuff": damage_percent_debuff_icon,
	"follow_up_buff": follow_up_buff_icon,
	"storm_buff": storm_buff_icon,
	"daze_debuff": daze_debuff_icon,
	"mana_crystal_buff": mana_crystal_buff_icon,
	"damage_taken_percent_debuff" : damage_taken_percent_debuff_icon,
	"fortitude_buff": fortitude_buff_icon
}
