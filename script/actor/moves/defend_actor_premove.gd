class_name DefendActorPremove
extends ActorPremove

var preview_amount : int

func _init(amt : int, _actor : Actor):
	super._init(_actor)
	amount = amt
	preview_amount = amt
	
func clone() -> DefendActorPremove:
	var copy = DefendActorPremove.new(amount, actor)
	copy.preview_amount = preview_amount
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

func refresh_amount(controller, context : BattleContext):
	var target = actor
	
	var armor_ctx = ArmorGainContext.new(
		target,
		amount,
		actor
	)
	
	preview_amount = controller.preview_armor(armor_ctx)
		
func get_amount():
	return str(preview_amount)

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ARMOR_ICON
