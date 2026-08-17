class_name CardView
extends Node

@export var _ui_path : NodePath
@onready var card_view_ui = get_node(_ui_path)

@export var card_ui_scene: PackedScene

var cards_ui_array: Array[Control] = []
@export var _card_ui_container_path: NodePath
@onready var card_ui_container = get_node(_card_ui_container_path)

var INPUT_TYPE = HandUI.InputType.VIEW

const SCROLL_SPEED = 5

@export var scrollable : bool = false

var columns : float = 6
var h_spacing = 72
var v_spacing = 104

@export var card_size := Vector2(70, 102)

@export var show_all_valid := false

func _ready():
	card_view_ui.visible = false
	
	if show_all_valid:
		display_cards(CardDatabase.get_all_valid_cards())
	
func _input(event: InputEvent) -> void:
	if not scrollable:
		return
	
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_UP:
		card_ui_container.global_position += Vector2(0, SCROLL_SPEED)
		calculate_positions()
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_DOWN:
		card_ui_container.global_position += Vector2(0, -SCROLL_SPEED)
		calculate_positions()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		card_ui_container.global_position += Vector2(0, SCROLL_SPEED)
		calculate_positions()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		card_ui_container.global_position += Vector2(0, -SCROLL_SPEED)
		calculate_positions()
		
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_K:
		card_view_ui.visible = not card_view_ui.visible
		
func display_cards(cards_dic : Array):
	var cards : Array[Card] = []
	
	for dic in cards_dic:
		cards.append(dic["SCRIPT"].new(dic["CARD_ID"]))
	
	display_cards_from_refcounted(cards)
	
func display_cards_from_refcounted(cards : Array):
	for i in range(cards.size()):
		if i >= cards_ui_array.size():
			var card = card_ui_scene.instantiate()
			card_ui_container.add_child(card)
			cards_ui_array.append(card)

			card.input_type = INPUT_TYPE
	for i in range(cards_ui_array.size()):
		if i >= cards.size():
			var card_ui = cards_ui_array[i]
			cards_ui_array.remove_at(i)
			card_ui.queue_free()
	for i in range(cards.size()):
		var card_logic = cards[i]
		var ui = cards_ui_array[i]
		# print(card_logic)
		ui.update_card_logic(card_logic)
		
	calculate_positions()
		
func calculate_positions():
	var column_count := int(columns)
	var total_cards := cards_ui_array.size()
	
	# Width of the entire grid, including the actual card sizes
	# and the gaps between cards.
	var grid_width = (
		column_count * card_size.x
		+ (column_count - 1) * (h_spacing - card_size.x)
	)
	
	var start_x = card_ui_container.global_position.x \
		+ (card_ui_container.size.x - grid_width) / 2.0
	
	for i in range(total_cards):
		var card_ui = cards_ui_array[i]
		
		var row := i / column_count
		var column := i % column_count
		
		var position := Vector2(
			start_x + column * h_spacing,
			card_ui_container.global_position.y + row * v_spacing
		)
		
		card_ui.drag_original_position = card_ui.hover_base_position
		
		card_ui.change_state(card_ui.idle_state)
		
		if card_ui.hover_tween:
			card_ui.hover_tween.kill()
		
		card_ui.hover_base_position = position
		card_ui.global_position = position
	
func clear_ui():
	for card in cards_ui_array:
		card.queue_free()
		
	cards_ui_array.clear()
