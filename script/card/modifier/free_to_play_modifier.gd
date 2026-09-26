class_name FreeToPlayModifier
extends CardModifier

func on_apply(card: Card, context:BattleContext, controller:BattleController):
	super.on_apply(card, context, controller)
	context.reset_hand_ui_cost()

func card_cost_request(ctx: CardCostRequestContext):
	if ctx.card == _owner:
		ctx.cost = 0
		
func get_name():
	return "Free"

func get_selection_prompt():
	return CardSelectionContext.SHARPEN_PROMPT
