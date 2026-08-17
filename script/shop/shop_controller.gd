class_name ShopController
extends RefCounted

var _player_data

signal player_data_change_request(data)

var reward_handler: RewardHandler
var reward_manager : BattleRewardsManager

var cards : Dictionary = {}
signal cards_updated(cards : Array)
var items : Dictionary = {}
signal items_updated(cards : Array)
var weapons : Dictionary = {}
signal weapons_updated(cards : Array)

func _init() -> void:
	reward_handler = RewardHandler.new()
	reward_handler.player_data_change_request.connect(
		func(t): player_data_change_request.emit(t)
	)
	reward_manager = BattleRewardsManager.new()

func get_reward_manager():
	return reward_manager
	
func set_rewards(shop_data : ShopData):
	cards = shop_data.cards
	cards_updated.emit(cards.keys())
	items = shop_data.items
	items_updated.emit(items.keys())
	weapons = shop_data.weapons
	weapons_updated.emit(weapons.keys())
	
func generate_rewards():
	var ctx = BattleWonContext.new()
	ctx.added_rare_pool_chance = 4
	var keys = reward_manager.generate_card_rewards(ctx, 8)
	var price_range = Vector2i(40, 50)
	var rare_price_range = Vector2i(50, 60)
	
	var item_price_range = Vector2i(45, 55)
	var weapon_price_range = Vector2i(65, 75)
	
	for key in keys:
		var card = key["SCRIPT"].new(key["CARD_ID"])
		if key["RARITY"] == "COMMON":
			cards[card] = randi_range(price_range.x, price_range.y)
		elif key["RARITY"] == "RARE":
			cards[card] = randi_range(rare_price_range.x, rare_price_range.y)
	
	cards_updated.emit(cards.keys())
	
	var item_keys = reward_manager.generate_item_rewards(ctx)
	var weapon_keys = reward_manager.generate_weapon_rewards(ctx)
	for key in item_keys:
		var item = key["SCRIPT"].new(key["ITEM_ID"])
		items[item] = randi_range(item_price_range.x, item_price_range.y)
	for key in weapon_keys:
		var item = key["SCRIPT"].new(key["ITEM_ID"])
		weapons[item] = randi_range(weapon_price_range.x, weapon_price_range.y)	
	weapons_updated.emit(weapons.keys())
	items_updated.emit(items.keys())
	
func get_cards() -> Array:
	return cards.keys()
	
func get_items() -> Array:
	return items.keys()
	
func get_weapons() -> Array:
	return weapons.keys()
	
func get_price_of_card(card):
	return cards[card]
	
func get_price_of_item(item):
	if item.is_weapon:
		return weapons[item]
	return items[item]
	
func process_reward(reward) -> void:
	reward_handler.process_reward(reward)

func bind_player_data(player_data : PlayerData):
	_player_data = player_data
	reward_manager.bind_items(player_data.items, player_data.weapon)

func request_player_data_modification(effect : PlayerDataEffect):
	player_data_change_request.emit(effect)
	
func request_purchase_card(card: Card):
	if _player_data.gold < get_price_of_card(card):
		return
	
	var context = RewardRequestContext.new()
	context.card_reward = card
	context.gold_reward = -get_price_of_card(card)
	
	reward_handler.process_reward(context)
	
	cards.erase(card)
	cards_updated.emit(cards.keys())
	
func request_purchase_item(item: Item):
	if _player_data.gold < get_price_of_item(item):
		return
	
	var context = RewardRequestContext.new()
	context.item_reward = item
	context.gold_reward = -get_price_of_item(item)
	
	reward_handler.process_reward(context)
	
	if item.is_weapon:
		weapons.erase(item)
		weapons_updated.emit(weapons.keys())
	else:
		items.erase(item)
		items_updated.emit(items.keys())
	
func process_item_replace(slot, item):
	var context = RewardRequestContext.new()
	context.item_reward = item
	context.item_slot_replace = slot
	
	reward_handler.process_reward(context)
