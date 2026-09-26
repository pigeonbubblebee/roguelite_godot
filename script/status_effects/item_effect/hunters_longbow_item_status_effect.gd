extends ItemStatusEffect

var triggered := false

func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	if card.get_base_cost() == 0 and not triggered:
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
			
		var esb = EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.move_card_to_hand(card)
		triggered = true
		esb.enqueue()
		
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_end(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
