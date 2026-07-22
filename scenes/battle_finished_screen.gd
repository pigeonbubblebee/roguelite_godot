extends Node2D

@export var _ui_path : NodePath
@onready var finished_ui = get_node(_ui_path)

@export var _card_reward_ui_path: NodePath
@onready var _card_reward_ui = get_node(_card_reward_ui_path)

@export var reward_button_scene : PackedScene
@export var _reward_button_container_path: NodePath
@onready var _reward_button_container = get_node(_reward_button_container_path)

signal request_reward(reward : RewardRequestContext)

var rewards_manager : BattleRewardsManager

var battle_won_context : BattleWonContext

func _ready():
	finished_ui.visible = false
	_card_reward_ui.mouse_filter = _card_reward_ui.MOUSE_FILTER_IGNORE
	
	_card_reward_ui.request_card_reward.connect(process_card_reward)
	
	add_reward_button(RewardButton.RewardType.CARD)
	add_reward_button(RewardButton.RewardType.GOLD, 15)
	
func add_reward_button(type : RewardButton.RewardType, amount : int = 0):
	var button = reward_button_scene.instantiate()
	_reward_button_container.add_child(button)
	
	button.reward_type = type
	button.reward_amount = amount
	
	button.pressed.connect(on_reward_button_pressed)
	
	button.change_text()
	
func bind(controller : BattleController):
	rewards_manager = (controller.get_reward_manager())	
	
func open_card_rewards():
	_card_reward_ui.mouse_filter = _card_reward_ui.MOUSE_FILTER_STOP
	_card_reward_ui.visible = true
	
	_card_reward_ui.init_rewards(rewards_manager.generate_card_rewards(battle_won_context))
	
func on_reward_button_pressed(type, amount):
	if type == RewardButton.RewardType.CARD:
		open_card_rewards()
	elif type == RewardButton.RewardType.GOLD:
		process_gold_reward(amount)
	
func bind_context(ctx : BattleWonContext):
	battle_won_context = ctx

func process_card_reward(card):
	var context = RewardRequestContext.new()
	context.card_reward = card

	_card_reward_ui.finish_rewards()
	
	request_reward.emit(context)

func process_gold_reward(gold):
	var context = RewardRequestContext.new()
	context.gold_reward = gold
	
	request_reward.emit(context)
