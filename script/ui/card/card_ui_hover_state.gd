class_name CardUIHoverState
extends CardUIState

func gui_input(event):
	#print(event is InputEventKey)
	if ((event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or 
		(event is InputEventKey and event.keycode == KEY_0)):
		if event.pressed:
			if card_ui.input_type == HandUI.InputType.BATTLE:
				if card_ui.can_drag:
					var drag_position := card_ui.get_global_mouse_position()

					if event is InputEventMouseButton:
						drag_position = event.global_position

					card_ui.start_drag(drag_position)
					card_ui.change_state(card_ui.drag_state)
			elif card_ui.input_type == HandUI.InputType.SELECTION:
				card_ui.emit_selection_started()
				card_ui.change_state(card_ui.selected_state)
			elif card_ui.input_type == HandUI.InputType.SHOP:
				card_ui.emit_purchase_request()
				#card_ui.change_state(card_ui.selected_state)

			# Check if card is locked
			# Otherwise, switch to darg
			pass
		
func enter():
	card_ui.z_index = 500
	card_ui.show_tooltip()
	
func exit():
	card_ui.z_index = card_ui.original_z
	card_ui.hide_tooltip()
			
func mouse_exited():
	card_ui.start_hover_reverse_tween()
	card_ui.emit_hover_ended()
	card_ui.change_state(card_ui.idle_state)
	# Change to Idle State
	# End Hover Tween
	# Emit Hover Ended
	pass
