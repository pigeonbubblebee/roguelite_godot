extends ItemStatusEffect

var smite_amount : int = 3
var smite_card_id : String = "smite_card"
var lifegain : int = 30

func on_battle_start(_context: BattleContext, _controller: BattleController):
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()

	EffectSequenceBuilder.new(_context, _controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.heal_actor(_owner, lifegain)\
		.add_card_to_hand(smite_card_id, smite_amount)\
		.enqueue()
