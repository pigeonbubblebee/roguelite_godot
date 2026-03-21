class_name DefendActorPremove
extends ActorPremove

func _init(amt : int, _actor : Actor):
	super._init(_actor)
	amount = amt
	
func clone() -> DefendActorPremove:
	var copy = DefendActorPremove.new(amount, actor)
	return copy

func execute(context: BattleContext, controller: BattleController):
	var action = BattleRuntimeHelper.generate_basic_defense_action(context, actor)

	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)

	EffectSequenceBuilder.new(context, controller)\
		.as_actor(actor)\
		.use_action(custom_action)\
		.armor(actor, amount)\
		.enqueue()
		
	await context.await_battle_actions()
	
	finished.emit()

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ARMOR_ICON
