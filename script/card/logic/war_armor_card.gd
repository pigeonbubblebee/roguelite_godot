class_name WarArmorCard
extends Card

var armor : int = 40
var status_id : String = "war_armor_status"
var stacks : int = 1
var damage_percent_gain : float = 0.6

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var effect = DamageAmplificationEffect.new(status_id, 
		stacks, damage_percent_gain)
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
