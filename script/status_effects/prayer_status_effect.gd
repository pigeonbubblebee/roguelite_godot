class_name PrayerStatusEffect
extends StatusEffect

func get_is_turn_based() -> bool:
	return false

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
		
	convert_prayer(battle_context, controller)
	
func convert_prayer(context, controller, amount := 1):
	var player = context.get_player()
	var effect = BlessingStatusEffect.new("blessing_status", 
		min(amount, _stacks))
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.apply_status(player, effect)\
		.enqueue()
	reduce_stacks(amount)
