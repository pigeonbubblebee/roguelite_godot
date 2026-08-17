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
var h_spacing = 45
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
		
func display_items(item_dic : Array):
	var items : Array[Item] = []
	
	for dic in item_dic:
		items.append(dic["SCRIPT"].new(dic["ITEM_ID"]))
	
	display_items_from_refcounted(items)
	
func display_items_from_refcounted(items : Array):
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
	var item_size := Vector2(36, 36)
	var column_count := int(columns)
	var total_items := item_ui_array.size()
	
	for i in range(total_items):
		var item_ui = item_ui_array[i]
		
		var row := i / column_count
		var column := i % column_count
		
		var items_in_row = min(
			column_count,
			total_items - row * column_count
		)
		
		# Width occupied by the actual item rectangles.
		var row_width = items_in_row * item_size.x
		
		# Add spacing between items.
		row_width += (items_in_row - 1) * (h_spacing - item_size.x)
		
		var start_x = item_ui_container.global_position.x \
			+ (item_ui_container.size.x - row_width) / 2.0
		
		var y = item_ui_container.global_position.y + row * v_spacing
		
		item_ui.global_position = Vector2(
			start_x + column * h_spacing,
			y
		)
	
	#var content_height = total_rows * v_spacing
	#var visible_height = item_ui_container.get_viewport_rect().size.y
	
func clear_ui():
	for item in item_ui_array:
		item.queue_free()
		
	item_ui_array.clear()
