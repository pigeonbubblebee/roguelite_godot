class_name WarArmorCard
extends Card

var armor : int = 40
var status_id : String = "war_armor_status"
var stacks : int = 1
var damage_percent_gain : float = 0.6

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var action = BattleRuntimeHelper.generate_basic_defense_action(context)
	controller.enqueue_action( action )
	
	var armor_context = ArmorGainContext.new(context.get_player(), armor, context.get_player())
	
	var effect = DamageAmplificationEffect.new(status_id, 
		stacks, damage_percent_gain)
	var application_status = StatusEffectApplicationContext.new(context.get_player(), effect, context.get_player())
	
	controller.apply_armor(armor_context)
	
	controller.apply_status(application_status)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
