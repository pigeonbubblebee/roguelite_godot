class_name CardUISelectedState
extends CardUIState

func enter():
	card_ui.show_highlight()
	card_ui.tween_to_selected()
	
func exit():
	card_ui.hide_highlight()

func gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			card_ui.emit_selection_ended()
			card_ui.change_state(card_ui.return_state)
