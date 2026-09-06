class_name ParryingDaggerCard
extends Card

var armor : int = 50
var status_stacks : int = 1
var status_id : String = "parrying_dagger_status"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var effect = NextCardCritStatusEffect.new(status_id, 
		status_stacks, 0.5)
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)
	var player = context.get_player()
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(player, armor)\
		.apply_status(player, effect)

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
