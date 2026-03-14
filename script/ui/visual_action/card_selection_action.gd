class_name CardSelectionAction
extends BattleVisualAction

var context : CardSelectionContext

func _init(_context : CardSelectionContext):
	context = _context

func execute(scene: BattleScene):
	started.emit()
	
	if context:
		await context.finished
	
	finished.emit()
