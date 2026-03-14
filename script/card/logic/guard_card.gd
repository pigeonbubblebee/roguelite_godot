class_name GuardCard
extends Card

var armor : int = 50

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var action = BattleRuntimeHelper.generate_basic_defense_action(context)
	controller.enqueue_action( action )
	
	var armor_context = ArmorGainContext.new(context.get_player(), armor, context.get_player())
	
	controller.apply_armor(armor_context)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
