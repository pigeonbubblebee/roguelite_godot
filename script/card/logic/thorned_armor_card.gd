class_name ThornedArmorCard
extends Card

const THORNED_ARMOR_DAMAGE_SOURCE_NAME = "thorned_armor_card"

var stacks : int = 1
var status_id : String = "thorned_armor_status"
var event_hook_name : String = "damage_dealt"
var armor: int = 50

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var player = context.get_player()
	
	var action = BattleRuntimeHelper.generate_basic_defense_action(context)
	controller.enqueue_action( action )
	
	var armor_context = ArmorGainContext.new(context.get_player(), armor, context.get_player())
	controller.apply_armor(armor_context)
	
	var effect = ThornedArmorStatusEffect.new(status_id, context.event_bus, 
		event_hook_name, stacks)
	var application_status = StatusEffectApplicationContext.new(player, effect, player)
	controller.apply_status(application_status)
	
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
