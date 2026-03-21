class_name SupportFireCard
extends Card

const SUPPORT_FIRE_DAMAGE_SOURCE_NAME = "support_fire_card"

var stacks : int = 2
var status_id : String = "support_fire_status"
var event_hook_name : String = "damage_dealt"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	var effect = SupportFireStatusEffect.new(
		status_id, 
		context.event_bus, 
		event_hook_name, 
		stacks)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.apply_status(player, effect)\
		.enqueue()
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
