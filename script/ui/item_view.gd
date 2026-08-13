class_name ItemView
extends Node

@export var _ui_path : NodePath
@onready var item_view_ui = get_node(_ui_path)

@export var item_ui_scene: PackedScene

var item_ui_array: Array[Control] = []
@export var _item_ui_container_path: NodePath
@onready var item_ui_container = get_node(_item_ui_container_path)

const SCROLL_SPEED = 5

@export var scrollable : bool = false

var columns : float = 6
var h_spacing = 38
var v_spacing = 38

@export var show_all_valid := false

@export var can_be_selected := true

func _ready():
	item_view_ui.visible = false
	
	if show_all_valid:
		display_items(ItemDatabase.get_all_valid_items())
	
func _input(event: InputEvent) -> void:
	if not scrollable:
		return
	
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_UP:
		item_ui_container.global_position += Vector2(0, SCROLL_SPEED)
		calculate_positions()
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_DOWN:
		item_ui_container.global_position += Vector2(0, -SCROLL_SPEED)
		calculate_positions()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		item_ui_container.global_position += Vector2(0, SCROLL_SPEED)
		calculate_positions()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		item_ui_container.global_position += Vector2(0, -SCROLL_SPEED)
		calculate_positions()
		
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_K:
		item_view_ui.visible = not item_view_ui.visible
		
func display_items(cards_dic : Array):
	var items : Array[Item] = []
	
	for dic in cards_dic:
		items.append(dic["SCRIPT"].new(dic["ITEM_ID"]))
	
	for i in range(items.size()):
		if i >= item_ui_array.size():
			var item = item_ui_scene.instantiate()
			item_ui_container.add_child(item)
			item_ui_array.append(item)

			item.can_be_selected = can_be_selected
	for i in range(item_ui_array.size()):
		if i >= items.size():
			var item_ui = item_ui_array[i]
			item_ui_array.remove_at(i)
			item_ui.queue_free()
	for i in range(items.size()):
		var item_logic = items[i]
		var ui = item_ui_array[i]
		# print(card_logic)
		ui.set_item(item_logic)
		
	calculate_positions()
		
func calculate_positions():
	var start_x = item_ui_container.global_position.x + item_ui_container.size.x / 2
	start_x -= columns/2 * h_spacing
	
	var start = Vector2(start_x, item_ui_container.global_position.y)
	
	for i in range(item_ui_array.size()):
		var item_ui = item_ui_array[i]
		
		var row = floor(i / columns)
		var column = i % int(columns)
			
		var offset : Vector2 = Vector2(h_spacing * column, v_spacing * row)

		item_ui.global_position = start + offset
		
	var total_rows = ceil(float(item_ui_array.size()) / columns)
	#card_ui_container.custom_minimum_size.y = total_rows * v_spacing
	
	var content_height = total_rows * v_spacing
	var visible_height = item_ui_container.get_viewport_rect().size.y
	
func clear_ui():
	for item in item_ui_array:
		item.queue_free()
		
	item_ui_array.clear()
