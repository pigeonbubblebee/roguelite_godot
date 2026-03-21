class_name FrostBarrierCard
extends Card

var armor : int = 140
var status_id : String = "fortitude_status"
var status_stacks : int = 4

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var player = context.get_player()
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)
	var effect = FortitudeStatusEffect.new(status_id, 
		status_stacks)
		
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.use_action(custom_action)\
		.armor(context.get_player(), armor)\
		.apply_status(player, effect)\
		.enqueue()
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
