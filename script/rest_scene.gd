class_name RestScene
extends Node

@export var exit_button_path : NodePath
@onready var exit_button = get_node(exit_button_path)

@export var heal_button_path : NodePath
@onready var heal_button = get_node(heal_button_path)
@export var remove_button_path : NodePath
@onready var remove_button = get_node(remove_button_path)

@export var card_view_ui_path : NodePath
@onready var card_view_ui = get_node(card_view_ui_path)

@export var _confirm_reward_button_path: NodePath
@onready var _confirm_reward_button = get_node(_confirm_reward_button_path)

var selected_card_index := -1

# HUD #
@export var hud_path : NodePath
@onready var hud = get_node(hud_path)
	
signal exit_requested(finished)
signal card_remove_requested(index: int)
	
var controller : RestController

func bind_controller(c : RestController):
	controller = c
	c.finish_rest.connect(func(): exit_requested.emit(true))
	
	heal_button.pressed.connect(controller.process_heal)
	remove_button.pressed.connect(init_rewards)
	
func _ready():
	exit_button.pressed.connect(exit)	
	
	_confirm_reward_button.pressed.connect(_on_confirm_remove_pressed)
	
func init_rewards():
	var awards = controller.get_current_deck()
	
	_confirm_reward_button.disabled = false
	card_view_ui.columns = 6
	
	card_view_ui.INPUT_TYPE = HandUI.InputType.SELECTION
	card_view_ui.scrollable = true
	
	card_view_ui.display_cards(awards)
	
	card_view_ui.visible = true
	
	for i in range(card_view_ui.cards_ui_array.size()):
		var card_ui = card_view_ui.cards_ui_array[i]
		
		if not card_ui.selection_started.is_connected(_on_card_selection_started):
			card_ui.selection_started.connect(
				_on_card_selection_started.bind(i)
			)
		
		if not card_ui.selection_ended.is_connected(_on_card_selection_ended):
			card_ui.selection_ended.connect(
				_on_card_selection_ended.bind(i)
			)
			
func _on_card_selection_started(_card: Card, index: int):
	for card_ui in card_view_ui.cards_ui_array:
		if not card_ui.card_logic == _card:
			card_ui.force_deselect()
	
	selected_card_index = index
	_confirm_reward_button.disabled = false


func _on_card_selection_ended(_card: Card, index: int):
	if selected_card_index == index:
		selected_card_index = -1
		_confirm_reward_button.disabled = true


func _on_confirm_remove_pressed():
	if selected_card_index == -1:
		return
	
	controller.remove_card(selected_card_index)
	
	selected_card_index = -1
	_confirm_reward_button.disabled = true
	card_view_ui.visible = false

	
func bind_game_manager(game_manager: GameManager):
	hud.bind_game_manager(game_manager)

func exit():
	exit_requested.emit(false)
