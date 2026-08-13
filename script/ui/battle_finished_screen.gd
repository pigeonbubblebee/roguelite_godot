extends Node2D

@export var _ui_path : NodePath
@onready var finished_ui = get_node(_ui_path)

@export var _card_reward_ui_path: NodePath
@onready var _card_reward_ui = get_node(_card_reward_ui_path)

@export var _item_reward_ui_path: NodePath
@onready var _item_reward_ui = get_node(_item_reward_ui_path)
@export var _item_replace_ui_path: NodePath
@onready var _item_replace_ui = get_node(_item_replace_ui_path)

@export var reward_button_scene : PackedScene
@export var _reward_button_container_path: NodePath
@onready var _reward_button_container = get_node(_reward_button_container_path)

signal request_reward(reward : RewardRequestContext)

var rewards_manager : BattleRewardsManager

var rewards_handler : RewardHandler

var battle_won_context : BattleWonContext

func _ready():
	finished_ui.visible = false
	_card_reward_ui.mouse_filter = _card_reward_ui.MOUSE_FILTER_IGNORE
	
	_card_reward_ui.request_card_reward.connect(process_card_reward)
	_item_reward_ui.request_item_reward.connect(process_item_reward)
	_item_replace_ui.request_item_replacement.connect(process_item_replace)
	
func add_reward_button(type : RewardButton.RewardType, amount : int = 0):
	var button = reward_button_scene.instantiate()
	_reward_button_container.add_child(button)
	
	button.reward_type = type
	button.reward_amount = amount
	
	button.pressed.connect(on_reward_button_pressed)
	
	button.change_text()
	
func bind(_rewards_manager : BattleRewardsManager, _rewards_handler : RewardHandler):
	rewards_manager = _rewards_manager
	rewards_handler = _rewards_handler
	
	rewards_handler.reward_interaction_requested.connect(_on_reward_interaction_requested)
	
func open_card_rewards():
	_card_reward_ui.mouse_filter = _card_reward_ui.MOUSE_FILTER_STOP
	_card_reward_ui.visible = true
	
	_card_reward_ui.init_rewards(rewards_manager.generate_card_rewards(battle_won_context))
	
func open_item_rewards():
	_item_reward_ui.mouse_filter = _item_reward_ui.MOUSE_FILTER_STOP
	_item_reward_ui.visible = true
	
	_item_reward_ui.init_rewards(rewards_manager.generate_item_rewards(battle_won_context))
	
func open_weapon_rewards():
	_item_reward_ui.mouse_filter = _item_reward_ui.MOUSE_FILTER_STOP
	_item_reward_ui.visible = true
	
	_item_reward_ui.init_rewards(rewards_manager.generate_weapon_rewards(battle_won_context))
	
func _on_reward_interaction_requested(request : ItemReplacementRequestContext):
	_item_replace_ui.mouse_filter = _item_replace_ui.MOUSE_FILTER_STOP
	_item_replace_ui.visible = true
	
	_item_replace_ui.init_replace(
		request.current_items,
		request.reward_item
	)
	
func on_reward_button_pressed(type, amount):
	if type == RewardButton.RewardType.CARD:
		open_card_rewards()
	elif type == RewardButton.RewardType.GOLD:
		process_gold_reward(amount)
	elif type == RewardButton.RewardType.KEY:
		process_key_reward()
	elif type == RewardButton.RewardType.ITEM:
		open_item_rewards()
	elif type == RewardButton.RewardType.WEAPON:
		open_weapon_rewards()
	
func bind_context(ctx : BattleWonContext):
	battle_won_context = ctx
	
	if ctx.has_card_reward:
		add_reward_button(RewardButton.RewardType.CARD)
		
	add_reward_button(RewardButton.RewardType.GOLD, 15 + ctx.original_gold_reward_variance)
		
	if ctx.has_item_reward:
		add_reward_button(RewardButton.RewardType.ITEM)
	if ctx.has_weapon_reward:
		add_reward_button(RewardButton.RewardType.WEAPON)
	
	if ctx.bonus_gold_reward > 0:
		add_reward_button(RewardButton.RewardType.GOLD, ctx.bonus_gold_reward)
	if ctx.key_rewards > 0:
		for i in ctx.key_rewards:
			add_reward_button(RewardButton.RewardType.KEY)

func process_card_reward(card):
	var context = RewardRequestContext.new()
	context.card_reward = card

	_card_reward_ui.finish_rewards()
	
	request_reward.emit(context)

func process_gold_reward(gold):
	var context = RewardRequestContext.new()
	context.gold_reward = gold
	
	request_reward.emit(context)
	
func process_key_reward():
	var context = RewardRequestContext.new()
	context.key_reward = true
	
	request_reward.emit(context)

func process_item_reward(item):
	var context = RewardRequestContext.new()
	context.item_reward = item

	_item_reward_ui.finish_rewards()
	
	request_reward.emit(context)

func process_item_replace(slot, item):
	if slot < 0:
		_item_replace_ui.finish_rewards()
		return
		
	var context = RewardRequestContext.new()
	context.item_reward = item
	context.item_slot_replace = slot

	_item_replace_ui.finish_rewards()
	
	request_reward.emit(context)
