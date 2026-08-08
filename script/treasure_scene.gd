class_name TreasureScene
extends Node

@export var exit_button_path : NodePath
@onready var exit_button = get_node(exit_button_path)

@export var finished_button_path : NodePath
@onready var finished_button = get_node(finished_button_path)

@export var open_button_path : NodePath
@onready var open_button = get_node(open_button_path)

# HUD #
@export var hud_path : NodePath
@onready var hud = get_node(hud_path)

@export var _reward_finished_button_path: NodePath
@onready var reward_finished_button = get_node(_reward_finished_button_path)
@export var _reward_ui_path: NodePath
@onready var reward_ui = get_node(_reward_ui_path)
@export var _reward_path: NodePath
@onready var reward = get_node(_reward_path)
	
signal exit_requested(finished)
	
var controller : TreasureController

func bind_controller(c : TreasureController):
	controller = c
	reward.request_reward.connect(controller.process_reward)
	
func _ready():
	exit_button.pressed.connect(exit)	
	finished_button.pressed.connect(func(): exit_requested.emit(true))
	
	_init_reward_screen()
	
	open_button.pressed.connect(_on_chest_open)
	
func bind_game_manager(game_manager: GameManager):
	hud.bind_game_manager(game_manager)

func exit():
	exit_requested.emit(false)
	
func _init_reward_screen():
	reward_ui.mouse_filter = reward_ui.MOUSE_FILTER_IGNORE
	reward_finished_button.mouse_filter = reward_finished_button.MOUSE_FILTER_IGNORE
	
	reward_ui.visible = false
	
func _on_chest_open():
	if not controller.can_open():
		return
	
	reward_ui.mouse_filter = reward_ui.MOUSE_FILTER_STOP
	reward_finished_button.mouse_filter = reward_finished_button.MOUSE_FILTER_STOP
	
	var effect = KeyChangePlayerDataEffect.new(-1)
	controller.request_player_data_modification(effect)
	
	reward_ui.visible = true
	reward.bind_context(controller.create_battle_won_context())
