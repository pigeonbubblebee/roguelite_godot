class_name MultiAttackActorPremove
extends ActorPremove

var source_name
var damage_type := DamageType.Type.PHYSICAL
var hits : int

var preview_amount : int

func _init(amt : int, _hits : int, source : String, _actor : Actor, _type : DamageType.Type = DamageType.Type.PHYSICAL):
	super._init(_actor)
	amount = amt
	source_name = source
	damage_type = _type
	preview_amount = amt
	hits = _hits
	
func clone() -> MultiAttackActorPremove:
	var copy = MultiAttackActorPremove.new(amount, hits, source_name, actor)
	copy.preview_amount = preview_amount
	return copy

func execute(context: BattleContext, controller: BattleController):
	var target = context.get_player()
	
	var sequence := EffectSequenceBuilder.new(context, controller)\
		.as_actor(actor)
	
	for i in range(hits):
		sequence.damage(target, amount, damage_type)

		if i < hits - 1:
			sequence.delay()
	
	sequence.enqueue()
			
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
	return str(preview_amount) + "x" + str(hits)
	
func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return ATTACK_ICON
