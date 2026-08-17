extends Control

@export var item_view_ui_path : NodePath
@onready var item_view_ui = get_node(item_view_ui_path)

@export var _confirm_reward_button_path: NodePath
@onready var _confirm_reward_button = get_node(_confirm_reward_button_path)

var selected_item : Item

signal request_item_reward(item : Item)

func _ready() -> void:
	self.visible = false
	_confirm_reward_button.pressed.connect(request_reward_confirmation)

func init_rewards(awards : Array):
	_confirm_reward_button.disabled = false
	item_view_ui.columns = awards.size()

	item_view_ui.scrollable = false
	
	item_view_ui.display_items(awards)
	
	item_view_ui.visible = true
	
	for item_ui in item_view_ui.item_ui_array:
		item_ui.selected.connect(on_selection_started)
			
func on_selection_started(item):
	for item_ui in item_view_ui.item_ui_array:
		if not item_ui.get_item() == item:
			item_ui.deselect()
	
	selected_item = item
	
func request_reward_confirmation():
	request_item_reward.emit(selected_item)
	
func finish_rewards():
	visible = false
	item_view_ui.clear_ui()
	selected_item = null
