extends ItemStatusEffect

var status_stacks : int = 1
var status_id : String = "steel_fang_status"

func on_turn_start(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		var effect = NextCardCritStatusEffect.new(status_id, 
		status_stacks, 1.0)
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		var player = battle_context.get_player()
		
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.discard_card()\
			.apply_status(player, effect)\
			.enqueue()
			
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		for status in actor.get_status_manager().get_active_status():
			if status.get_status_id() == "steel_fang_status":
				status.reduce_stacks()

func on_battle_start(context: BattleContext, controller:BattleController):
	var effect = NextCardCritStatusEffect.new(status_id, 
	status_stacks, 1.0)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	var player = context.get_player()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.discard_card()\
		.apply_status(player, effect)\
		.enqueue()
