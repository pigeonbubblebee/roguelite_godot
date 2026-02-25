class_name CardUIDragState
extends CardUIState

func gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			card_ui.change_state(card_ui.play_process_state)
			card_ui.request_attempt_card_play()
			end_drag()
			pass
	elif event is InputEventMouseMotion:
		card_ui.drag(event.global_position)
		
func end_drag():
	card_ui.emit_hover_ended()
	card_ui.emit_drag_ended()
	card_ui.end_drag()
	
func force_drag_end():
	end_drag()
	card_ui.change_state(card_ui.return_state)

func enter():
	card_ui.emit_drag_started()
	
func exit():
	card_ui.emit_drag_ended()
