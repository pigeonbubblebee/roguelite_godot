class_name ConcussCard
extends Card

var status_buildup : int = 4
var status_id : String = "daze_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()

	var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.apply_status(target, effect)\
		.enqueue()
