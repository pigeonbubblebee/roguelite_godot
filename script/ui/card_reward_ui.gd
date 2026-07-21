extends Control

@export var card_view_ui_path : NodePath
@onready var card_view_ui = get_node(card_view_ui_path)

@export var _confirm_reward_button_path: NodePath
@onready var _confirm_reward_button = get_node(_confirm_reward_button_path)

var selected_card : Card

signal request_card_reward(card : Card)

func _ready() -> void:
	self.visible = false
	_confirm_reward_button.pressed.connect(request_reward_confirmation)

func init_rewards(awards : Array):
	card_view_ui.columns = awards.size()
	
	card_view_ui.INPUT_TYPE = HandUI.InputType.SELECTION
	card_view_ui.scrollable = false
	
	card_view_ui.display_cards(awards)
	
	card_view_ui.visible = true
	
	for card_ui in card_view_ui.cards_ui_array:
		card_ui.selection_started.connect(on_selection_started)
			
func on_selection_started(card):
	for card_ui in card_view_ui.cards_ui_array:
		if not card_ui.card_logic == card:
			card_ui.force_deselect()
	
	selected_card = card
	
func request_reward_confirmation():
	request_card_reward.emit(selected_card)
	
func finish_rewards():
	visible = false
	card_view_ui.clear_ui()
