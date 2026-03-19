class_name DischargeStatusEffect
extends StatusEffect

var storm_status_id = "storm_status"

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)

func on_turn_end(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
		
	var status = _owner.get_status_manager().get_active_status()
		
	for st in status:
		if st.get_status_id() == storm_status_id:
			st.reduce_stacks(_stacks)
			pass
	
	reduce_stacks(_stacks)

	
func get_is_turn_based() -> bool:
	return false
