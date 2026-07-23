class_name DebuffActorPremove
extends ActorPremove

var source_name
var factory

func _init(amt : int, source : String, _actor : Actor, effect_factory: Callable):
	super._init(_actor)
	amount = amt
	source_name = source
	factory = effect_factory
	
func clone() -> DebuffActorPremove:
	var copy = DebuffActorPremove.new(amount, source_name, actor, factory)
	return copy

func execute(context: BattleContext, controller: BattleController):
	var target = context.get_player()
	
	var effect = factory.call(target)
	var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_actor(actor)\
		.use_action(custom_action)\
		.apply_status(target, effect)\
		.enqueue()
		
	await context.await_battle_actions()
	
	finished.emit()

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return DEBUFF_ICON
