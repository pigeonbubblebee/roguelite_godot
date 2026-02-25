class_name CardUIIdleState
extends CardUIState

func mouse_entered():
	
	# Enter Hover State
	# Start Hover Tween
	# Emit Hover Started Signal
	
	if(not card_ui.can_hover):
		return
	
	card_ui.start_hover_tween()
	card_ui.emit_hover_started()
	
	card_ui.change_state(card_ui.hover_state)
