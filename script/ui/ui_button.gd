class_name UIButton
extends Control

signal pressed

var disabled := false
@export var one_shot := false

# Detect Drag
func _gui_input(event):
	if disabled:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			pressed.emit()
			
			if one_shot:
				disabled = true
