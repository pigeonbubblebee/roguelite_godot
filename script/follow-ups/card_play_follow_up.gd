class_name CardPlayFollowUp
extends FollowUp

var behavior: Callable
var card_id : String

func _init(_behavior: Callable, _card_id : String):
	behavior = _behavior
	
	card_id = _card_id

func execute(context: BattleContext, controller: BattleController):
	if behavior.is_valid():
		EffectSequenceBuilder.new(context, controller)\
			.as_follow_up(self)\
			.use_action(ParallelAction.new([]))\
			.step(
				CardArtAction.new(context.get_player(), card_id),
				func():behavior.call(context, controller)
			)\
			.enqueue()
		
func get_follow_up_id() -> String:
	return card_id
