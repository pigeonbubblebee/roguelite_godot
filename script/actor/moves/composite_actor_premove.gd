class_name CompositeActorPremove
extends ActorPremove

var premoves: Array[ActorPremove]

func _init(_actor: Actor, _premoves: Array[ActorPremove]):
	super._init(_actor)

	for move in _premoves:
		premoves.append(move)

func clone() -> CompositeActorPremove:
	var cloned_moves: Array[ActorPremove] = []

	for move in premoves:
		cloned_moves.append(move.clone())

	return CompositeActorPremove.new(actor, cloned_moves)


func execute(context: BattleContext, controller: BattleController):
	var remaining := premoves.size()

	if remaining == 0:
		finished.emit()
		return

	for move in premoves:
		move.execute(context, controller)
	await context.await_battle_actions()
	finished.emit()

func get_icon() -> Texture2D:
	if premoves.is_empty():
		return null

	return premoves[0].get_icon()
	
func get_amount():
	if premoves.is_empty():
		return null
		
	return premoves[0].get_amount()
