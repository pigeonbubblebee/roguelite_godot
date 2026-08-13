class_name NextCardFreeStatusEffect
extends StatusEffect

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	_context.reset_hand_ui_cost()
	
func card_cost_request(_context : CardCostRequestContext):
	_context.cost = 0
	
func before_card_played(card: Card, context: BattleContext, controller: BattleController):
	reduce_stacks()
	context.reset_hand_ui_cost()
	
func get_is_turn_based() -> bool:
	return false
