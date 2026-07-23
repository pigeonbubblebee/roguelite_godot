class_name ShuffleWoundPremove
extends ActorPremove

var card_id

func _init(amt : int, id : String, _actor : Actor):
	super._init(_actor)
	amount = amt
	card_id = id
	
func clone() -> ShuffleWoundPremove:
	var copy = ShuffleWoundPremove.new(amount, card_id, actor)
	return copy

func execute(context: BattleContext, controller: BattleController):
	var target = context.get_player()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_actor(actor)\
		.shuffle_card_to_deck(card_id, amount)\
		.enqueue()
		
	await context.await_battle_actions()
	
	finished.emit()

func _finish_move():
	finished.emit()

func get_icon() -> Texture2D:
	return DEBUFF_ICON
