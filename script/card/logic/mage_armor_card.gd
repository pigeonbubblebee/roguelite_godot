class_name MageArmorCard
extends Card

var armor : int = 80

var mana_crystal_card_id : String = "mana_crystal_card"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)

	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(context.get_player(), armor)\
		.add_card_to_hand(mana_crystal_card_id)\
		.enqueue()

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
