extends ItemStatusEffect

var status_stacks : int = 5
var status_id : String = "rage_status"

func on_battle_start(_context: BattleContext, _controller: BattleController):
	var effect = RageStatusEffect.new(status_id, 
		status_stacks * _stacks)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(_context, _controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.apply_status(_context.get_player(), effect)\
		.enqueue()
