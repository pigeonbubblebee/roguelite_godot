class_name GuardCard
extends Card

var armor : int = 50

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)

	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(context.get_player(), armor)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
