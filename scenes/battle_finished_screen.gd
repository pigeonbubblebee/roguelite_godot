extends Node2D

@export var _ui_path : NodePath
@onready var finished_ui = get_node(_ui_path)

@export var _open_card_reward_button_path: NodePath
@onready var _open_card_reward_button = get_node(_open_card_reward_button_path)

@export var _card_reward_ui_path: NodePath
@onready var _card_reward_ui = get_node(_card_reward_ui_path)

signal request_reward(reward : RewardRequestContext)

var rewards_manager : BattleRewardsManager

var battle_won_context : BattleWonContext

func _ready():
	finished_ui.visible = false
	_card_reward_ui.mouse_filter = _card_reward_ui.MOUSE_FILTER_IGNORE
	_open_card_reward_button.pressed.connect(open_card_rewards)
	
	_card_reward_ui.request_card_reward.connect(process_card_reward)
	
func bind(controller : BattleController):
	rewards_manager = (controller.get_reward_manager())	
	
func open_card_rewards():
	_card_reward_ui.mouse_filter = _card_reward_ui.MOUSE_FILTER_STOP
	_card_reward_ui.visible = true
	
	_card_reward_ui.init_rewards(rewards_manager.generate_card_rewards(battle_won_context))
	
func bind_context(ctx : BattleWonContext):
	battle_won_context = ctx

func process_card_reward(card):
	var context = RewardRequestContext.new()
	context.card_reward = card

	_open_card_reward_button.visible = false
	_card_reward_ui.finish_rewards()
	
	request_reward.emit(context)
