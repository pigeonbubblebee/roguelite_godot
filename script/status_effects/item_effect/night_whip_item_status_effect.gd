extends ItemStatusEffect

var triggered := false

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	_context.reset_hand_ui_cost()
	
func card_cost_request(_context : CardCostRequestContext):
	if not triggered:
		_context.cost = 0
	
func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	triggered = true
	context.reset_hand_ui_cost()
	EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.use_action(BattleRuntimeHelper.generate_light_camera_shake_action())\
			.lose_life(context.get_player(), 30)\
			.enqueue()
	
func on_turn_start(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_start(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
		battle_context.reset_hand_ui_cost()
