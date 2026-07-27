class_name EscapeActorPremove
extends ActorPremove

func _init(amt : int, _actor : Actor):
	super._init(_actor)
	amount = amt
	
func clone() -> EscapeActorPremove:
	var copy = EscapeActorPremove.new(amount, actor)
	return copy

func execute(context: BattleContext, controller: BattleController):
	controller.free_actor(actor)
	
	await context.await_battle_actions()
	 
	finished.emit()

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ESCAPE_ICON
