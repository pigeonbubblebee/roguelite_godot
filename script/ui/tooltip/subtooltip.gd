class_name Subtooltip
extends Control

@export var _tooltip_label_path : NodePath
@onready var tooltip_label = get_node(_tooltip_label_path)

@export var _control_path : NodePath
@onready var control = get_node(_control_path)

func set_description(text : String):
	tooltip_label.text = text

func show_tooltip():
	resize()
		
	self.visible = true	

func hide_tooltip():
	self.visible = false	

	queue_free()

func resize():
	var text_size = tooltip_label.get_minimum_size().y
	
	control.set_custom_minimum_size(Vector2(141, text_size + 8))
	control.position.y = -control.size.y
