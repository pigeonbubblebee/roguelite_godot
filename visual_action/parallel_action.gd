class_name ParallelAction
extends BattleVisualAction

var actions: Array[BattleVisualAction]
var remaining := 0

func _init(action_list: Array[BattleVisualAction]):
	actions = action_list
	
func append_action(action: BattleVisualAction):
	actions.append(action)

func execute(context):
	if actions.is_empty():
		return

	remaining = actions.size()

	for action in actions:
		action.finished.connect(_on_sub_action_finished, CONNECT_ONE_SHOT)

	for action in actions:
		action.execute(context)

func _on_sub_action_finished():
	remaining -= 1
	if remaining <= 0:
		emit_signal("finished")
