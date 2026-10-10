class_name DivineJudgementStatusEffect
extends StatusEffect

func get_is_turn_based() -> bool:
	return false

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	_context.reset_hand_ui_cost()
	
func card_cost_request(_context : CardCostRequestContext):
	if _context.card.id == "smite_card":
		_context.cost -= 1
