class_name AggressionStatusEffect
extends StatusEffect

var status_id = "rage_status"

func get_is_turn_based() -> bool:
	return false

func on_turn_started_after_action(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
		
	var effect = RageStatusEffect.new(status_id, 
		_stacks*AggressionCard.RAGE_AMOUNT)
		
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.apply_status(_owner, effect)\
		.enqueue()
