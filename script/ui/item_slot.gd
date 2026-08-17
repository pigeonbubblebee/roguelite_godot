extends Control

@export var _texture_path: NodePath
@onready var texture = get_node(_texture_path)
@export var _select_texture_path: NodePath
@onready var select_texture = get_node(_select_texture_path)

var _item : Item

var empty_texture := preload("res://assets/item_art/empty_item.png")

# TEMP TBD: Make tooltip logic recursive
@onready var tooltip_offset = Vector2(0, -60)
@onready var tooltip_base_offset = Vector2(0, 55)

signal tooltip_hide_request

var can_be_selected : bool = false
var can_be_purchased : bool = false

var is_selected = false

signal deselected(item)
signal selected(item)

signal purchase_requested(item)

@export var _price_path: NodePath
@onready var price = get_node(_price_path)

func _ready():
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)
	
	select_texture.visible = false
	
	price.visible = false

func get_item() -> Item:
	return _item

func set_item(item: Item):
	_item = item
	
	if not _item:
		texture.texture = empty_texture
		return
	
	texture.texture = _item.texture

func show_tooltip():
	var base_position = global_position + tooltip_base_offset
	var desc = KeywordFormatter.format_text(_item.get_description())
	TooltipRequestBus.request_tooltip(TooltipData.new()\
		.add_description(desc)\
		.add_starting_position(base_position)\
		.add_offset(tooltip_offset)\
		.add_hide_event(self, "tooltip_hide_request"))#\
		#.add_keywords(card_logic.get_keywords()))
	
func hide_tooltip():
	tooltip_hide_request.emit()
	
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if can_be_selected:
				if not is_selected:
					selected.emit(_item)
					select_texture.visible = true
					is_selected = true
				else:
					deselect()
					
			if can_be_purchased:
				purchase_requested.emit(_item)
			
func deselect():
	select_texture.visible = false
	is_selected = false

func _on_mouse_enter():
	if _item:
		show_tooltip()

func _on_mouse_exit():
	if _item:
		hide_tooltip()
				
func show_price(amount:int):
	price.text = str(amount) + " GOLD"
	price.visible = true
