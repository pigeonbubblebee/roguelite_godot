class_name DivinationCard
extends Card

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.draw_card(3)\
		.discard_card(2)\
		.enqueue()

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
