class_name SplitActorPremove
extends ActorPremove

var enemy_resource

func _init(amt : int, _actor : Actor, resource : ActorData):
	super._init(_actor)
	amount = amt
	enemy_resource = resource
	
func clone() -> SplitActorPremove:
	var copy = SplitActorPremove.new(amount, actor, enemy_resource)
	return copy

func execute(context: BattleContext, controller: BattleController):
	controller.free_actor(actor)
	
	await context.await_battle_actions()
	
	var arr : Array
	for i in range(amount):
		arr.append({"data": enemy_resource, "premove_index": 0})
	controller.add_actors(arr)	
	
	
	var action = BattleRuntimeHelper.generate_light_camera_shake_action()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_actor(actor)\
		.use_action(action)\
		.enqueue()
		
	await context.await_battle_actions()
	 
	finished.emit()

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return BUFF_ICON
