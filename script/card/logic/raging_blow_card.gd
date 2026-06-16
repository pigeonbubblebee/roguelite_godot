class_name RagingBlowCard
extends Card

var status_stacks : int = 3
var status_id : String = "rage_status"
var damage : int = 190

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	var player = context.get_player()
	var effect = RageStatusEffect.new(status_id, 
		status_stacks)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.apply_status(player, effect)\
		.enqueue()
