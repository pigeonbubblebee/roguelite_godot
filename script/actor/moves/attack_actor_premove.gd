class_name AttackActorPremove
extends ActorPremove

var source_name
var damage_type := DamageType.Type.PHYSICAL

var preview_amount : int

func _init(amt : int, source : String, _actor : Actor, _type : DamageType.Type = DamageType.Type.PHYSICAL):
	super._init(_actor)
	amount = amt
	source_name = source
	damage_type = _type
	preview_amount = amt
	
func clone() -> AttackActorPremove:
	var copy = AttackActorPremove.new(amount, source_name, actor)
	copy.preview_amount = preview_amount
	return copy

func execute(context: BattleContext, controller: BattleController):
	var target = context.get_player()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_actor(actor)\
		.damage(target, amount, damage_type)\
		.enqueue()
		
	await context.await_battle_actions()
	
	finished.emit()
	
func refresh_amount(controller, context : BattleContext):
	var target = context.get_player()
	
	var hit_actors : Array[Actor] = [target]
	
	var dmg = BattleRuntimeHelper.generate_damage_context(
		amount,
		hit_actors,
		actor
	)
		
	dmg.source = actor
	
	var dict : Dictionary = controller.preview_damage(dmg)
	
	if dict.has(target):
		preview_amount = dict[target]
		
func get_amount():
	return str(preview_amount)
	
func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ATTACK_ICON
