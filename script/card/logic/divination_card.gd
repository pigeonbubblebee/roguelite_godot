class_name DivinationCard
extends Card

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var action = ParallelAction.new(
		[BattleRuntimeHelper.generate_light_camera_shake_action()])
	
	var discard_selection_context = BattleRuntimeHelper.generate_discard_card_selection_context(context, controller, 2)
	action.append_action(CardSelectionAction.new(discard_selection_context))
	
	controller.enqueue_action(action)
	
	controller.draw_card(3)
	
	# Discards 2
	controller.start_card_selection(discard_selection_context)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
