extends Node2D

@export var _ui_path : NodePath
@onready var card_view_ui = get_node(_ui_path)

@export var card_ui_scene: PackedScene

var cards_ui_array: Array[Control] = []
@export var _card_ui_container_path: NodePath
@onready var card_ui_container = get_node(_card_ui_container_path)

const INPUT_TYPE = HandUI.InputType.VIEW

const SCROLL_SPEED = 5

func _ready():
	card_view_ui.visible = false
	
	display_cards(CardDatabase.get_all_valid_cards())
	
func _input(event: InputEvent) -> void:
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
	var columns = 6
	
	var h_spacing = 72
	var v_spacing = 104
	
	var start_x = card_ui_container.global_position.x + card_ui_container.size.x / 2
	start_x -= columns/2 * h_spacing
	
	var start = Vector2(start_x, card_ui_container.global_position.y)
	
	for i in range(cards_ui_array.size()):
		var card_ui = cards_ui_array[i]
		
		var row = floor(i / columns)
		var column = i % columns
			
		var offset : Vector2 = Vector2(h_spacing * column, v_spacing * row)
			
		card_ui.drag_original_position = card_ui.hover_base_position
		
		card_ui.change_state(card_ui.idle_state)
		card_ui.hover_base_position = start + offset
		
		if card_ui.hover_tween:
			card_ui.hover_tween.kill()
		card_ui.global_position = card_ui.hover_base_position
		
	var total_rows = ceil(float(cards_ui_array.size()) / columns)
	#card_ui_container.custom_minimum_size.y = total_rows * v_spacing
	
	var content_height = total_rows * v_spacing
	var visible_height = card_ui_container.get_viewport_rect().size.y
