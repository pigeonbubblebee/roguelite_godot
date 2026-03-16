class_name CardPlayFollowUp
extends FollowUp

var behavior: Callable
var card_id : String

func _init(_behavior: Callable, _card_id : String):
	behavior = _behavior
	
	card_id = _card_id


func execute(context: BattleContext, controller: BattleController):
	if behavior.is_valid():
		var action = CardArtAction.new(context.get_player(), card_id)
		
		action.started.connect(func():behavior.call(context, controller))
		
		controller.enqueue_action(action)
