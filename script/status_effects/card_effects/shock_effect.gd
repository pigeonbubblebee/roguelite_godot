class_name ShockEffect
extends StatusEffect

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	_context.event_bus.on_card_played.connect(on_card_played)

func on_card_played(card, b_context, controller):
	var player = b_context.get_player()
	
	var status = player.get_status_manager().get_active_status()
	
	for st in status:
		if st.get_status_id() == "storm_status":
			st.reduce_stacks()
			pass
	reduce_stacks()
	
func get_is_turn_based() -> bool:
	return false
