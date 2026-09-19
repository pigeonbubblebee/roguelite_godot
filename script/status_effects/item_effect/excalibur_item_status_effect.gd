extends ItemStatusEffect

var armor = 5
var status_id = "resolve_status"
var turns = 3

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		var hand = controller.get_hand_manager().get_hand()
		
		for card in hand:
			if card.id == "smite_card":				
				var player = battle_context.get_player()
				var effect = ResolveStatusEffect.new(status_id, 
					turns)
				var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
				
				EffectSequenceBuilder.new(battle_context, controller)\
					.as_status(self)\
					.use_action(custom_action)\
					.remove_without_selection(card)\
					.apply_status(player, effect)\
					.enqueue()
					
				return
