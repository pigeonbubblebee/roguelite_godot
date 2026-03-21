class_name CardUIReturnState
extends CardUIState

func enter():
	card_ui.tween_to_hand()
	
	card_ui.return_to_hand_tween_finished.connect(func():
		card_ui.change_state(card_ui.idle_state)
	)
	
	# Tween to original position in hand
	# Enter idle state
	pass
