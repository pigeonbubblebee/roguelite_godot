class_name ManaCrystalCard
extends Card

var stacks : int = 1
var status_id : String = "mana_crystal_status"

func effect_on_resolve(context, controller):
	return ResolveEffect.REMOVE

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	
	controller.enqueue_action(BattleRuntimeHelper.generate_light_camera_shake_action())
	
	var effect = ManaCrystalEffect.new(status_id, player, 
		stacks)
	var application_status = StatusEffectApplicationContext.new(player, effect, context.get_player())
	controller.apply_status(application_status)
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
