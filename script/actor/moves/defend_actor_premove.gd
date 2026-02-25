class_name DefendActorPremove
extends ActorPremove

func _init(amt : int, _actor : Actor):
	super._init(_actor)
	amount = amt
	
func clone() -> DefendActorPremove:
	var copy = DefendActorPremove.new(amount, actor)
	return copy

func execute(context: BattleContext, controller: BattleController):
	
	controller.apply_armor(amount, actor)
	
	var action = BattleRuntimeHelper.generate_basic_defense_action(context, actor)

	action.finished.connect(_finish_move)
	
	controller.enqueue_action(action)

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ARMOR_ICON
