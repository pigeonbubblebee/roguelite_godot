class_name MageArmorCard
extends Card

var armor : int = 80

var channel_card_id : String = "mana_crystal_card"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var action = BattleRuntimeHelper.generate_basic_defense_action(context)
	controller.enqueue_action( action )
	
	var armor_context = ArmorGainContext.new(context.get_player(), armor, context.get_player())
	
	controller.apply_armor(armor_context)
	
	controller.add_card_to_hand(channel_card_id)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
