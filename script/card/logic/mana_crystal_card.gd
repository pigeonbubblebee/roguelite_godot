class_name ManaCrystalCard
extends Card

var stacks : int = 1
var status_id : String = "mana_crystal_status"

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	var effect = ManaCrystalStatusEffect.new(status_id, 
		stacks)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.apply_status(player, effect)\
		.enqueue()
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
