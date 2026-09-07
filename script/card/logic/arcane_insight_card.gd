class_name ArcaneInsightCard
extends Card

var mana_burn_card_id = "mana_burn_card"
var turns : int = 3
var status_id : String = "empowered_status"
var armor : int = 40

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var player = context.get_player()
	var effect = DamageAmplificationStatusEffect.new(status_id, 
		turns)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.apply_status(player, effect)\
		.armor(player, armor)\
		.shuffle_card_to_deck(mana_burn_card_id)
