class_name FortitudeEffect
extends StatusEffect

func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)


func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	_context.event_bus.on_armor_reset_request.connect(on_armor_reset_request)

func on_armor_reset_request(context:ArmorResetContext, b_context, controller):
	if not context.actor == _owner:
		return
	
	var amount = min(_stacks, floor(context.amount / 10))
	
	context.amount_reduction += 10 * amount
	
	reduce_stacks(amount)
	
func get_is_turn_based() -> bool:
	return false
