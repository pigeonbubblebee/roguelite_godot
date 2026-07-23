class_name ArmorAttackActorPremove
extends ActorPremove

var source_name
var damage_type := DamageType.Type.PHYSICAL
var block_amount

func _init(amt : int, source : String, _actor : Actor, _block : int, _type : DamageType.Type = DamageType.Type.PHYSICAL):
	super._init(_actor)
	amount = amt
	source_name = source
	damage_type = _type
	block_amount = _block
	
func clone() -> ArmorAttackActorPremove:
	var copy = ArmorAttackActorPremove.new(amount, source_name, actor, block_amount)
	return copy

func execute(context: BattleContext, controller: BattleController):
	var target = context.get_player()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_actor(actor)\
		.damage(target, amount, damage_type)\
		.armor(actor, block_amount)\
		.enqueue()
		
	await context.await_battle_actions()
	
	finished.emit()

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ARMOR_ATTACK_ICON
