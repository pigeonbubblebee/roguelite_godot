class_name AttackActorPremove
extends ActorPremove

var source_name

func _init(amt : int, source : String, _actor : Actor):
	super._init(_actor)
	amount = amt
	source_name = source

func execute(context: BattleContext, controller: BattleController):
	var player = context.get_player()
	
	var hit_actors: Array[Actor] = [ player ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(amount, hit_actors)	
	damage_context.source_name = source_name
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context, actor)
	action.append_action(PlayParticleEffectAction.new(player))
	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)

	action.finished.connect(_finish_move)

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ATTACK_ICON
