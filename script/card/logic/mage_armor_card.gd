class_name MageArmorCard
extends Card

var armor : int = 60

var mana_crystal_card_id : String = "mana_crystal_card"

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)

	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(context.get_player(), armor)\
		.add_card_to_hand(mana_crystal_card_id)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
