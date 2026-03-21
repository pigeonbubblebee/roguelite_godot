class_name AttackActorPremove
extends ActorPremove

var source_name
var damage_type := DamageType.Type.PHYSICAL

func _init(amt : int, source : String, _actor : Actor, _type : DamageType.Type = DamageType.Type.PHYSICAL):
	super._init(_actor)
	amount = amt
	source_name = source
	damage_type = _type
	
func clone() -> AttackActorPremove:
	var copy = AttackActorPremove.new(amount, source_name, actor)
	return copy

func execute(context: BattleContext, controller: BattleController):
	var target = context.get_player()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_actor(actor)\
		.damage(target, amount, damage_type)\
		.enqueue()
		
	await context.await_battle_actions()
	
	finished.emit()

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ATTACK_ICON
