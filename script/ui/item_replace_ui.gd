extends Control

@export var current_item_view_ui_path: NodePath
@onready var current_item_view_ui = get_node(current_item_view_ui_path)

@export var selected_item_view_ui_path: NodePath
@onready var selected_item_view_ui = get_node(selected_item_view_ui_path)

@export var _confirm_reward_button_path: NodePath
@onready var _confirm_reward_button = get_node(_confirm_reward_button_path)

var selected_slot: int = -1
var reward_item: Item

signal request_item_replacement(slot: int, item: Item)

func _ready() -> void:
	visible = false

	_confirm_reward_button.pressed.connect(
		request_reward_confirmation
	)

func init_replace(current_items: Array, selected_item: Dictionary) -> void:
	visible = true

	selected_slot = -1
	reward_item = selected_item["SCRIPT"].new(selected_item["ITEM_ID"])

	# Current inventory
	current_item_view_ui.columns = current_items.size() / 2
	current_item_view_ui.scrollable = false
	current_item_view_ui.display_items(current_items)
	current_item_view_ui.visible = true

	# Reward item
	selected_item_view_ui.columns = 1
	selected_item_view_ui.scrollable = false
	selected_item_view_ui.display_items([selected_item])
	selected_item_view_ui.visible = true
	selected_item_view_ui.can_be_selected = false

	# Current items are selectable
	for i in current_item_view_ui.item_ui_array.size():
		var item_ui = current_item_view_ui.item_ui_array[i]

		item_ui.selected.connect(
			on_selection_started.bind(i)
		)

		item_ui.deselected.connect(
			on_selection_ended.bind(i)
		)

func on_selection_started(item: Item, slot: int) -> void:
	selected_slot = slot

	for i in current_item_view_ui.item_ui_array.size():
		if i != slot:
			current_item_view_ui.item_ui_array[i].deselect()

func on_selection_ended(item: Item, slot: int) -> void:
	if selected_slot == slot:
		selected_slot = -1

func request_reward_confirmation() -> void:
	if reward_item == null:
		return

	request_item_replacement.emit(
		selected_slot,
		reward_item
	)


func finish_rewards() -> void:
	visible = false

	selected_slot = -1
	reward_item = null

	current_item_view_ui.clear_ui()
	selected_item_view_ui.clear_ui()
