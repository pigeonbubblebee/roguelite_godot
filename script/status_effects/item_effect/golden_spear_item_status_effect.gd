extends ItemStatusEffect

var turns : int = 1
var status_id : String = "prayer_status"
var smite_card_id = "smite_card"
var triggered := false

func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	if card.id == smite_card_id and not triggered:
		var player = context.get_player()
		var effect = PrayerStatusEffect.new(status_id, 
			turns)
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		
		EffectSequenceBuilder.new(context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.apply_status(player, effect)\
			.enqueue()

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_end(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
