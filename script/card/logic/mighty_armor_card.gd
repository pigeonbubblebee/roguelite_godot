class_name MightyArmorCard
extends Card

var armor : int = 80
var status_turns : int = 2
var status_id : String = "empowered_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var effect = DamageAmplificationStatusEffect.new(status_id, 
		status_turns)
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)
	var player = context.get_player()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(player, armor)\
		.apply_status(player, effect)\
		.enqueue()

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
