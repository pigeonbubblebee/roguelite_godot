extends ItemStatusEffect

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	_context.reset_hand_ui_cost()
	
func card_cost_request(_context : CardCostRequestContext):
	if _context.card.get_base_cost() >= 2:
		_context.cost -= 1
