class_name BreachingShieldCard
extends Card

var armor : int = 70
var status_id = "next_card_free_status"
var stacks = 1

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)
	var effect = NextCardFreeStatusEffect.new(status_id, 
		stacks)
		
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(context.get_player(), armor)\
		.apply_status(context.get_player(), effect)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
