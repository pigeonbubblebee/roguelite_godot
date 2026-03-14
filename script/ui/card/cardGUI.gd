class_name CardGUI
extends Control

var drag_offset := Vector2.ZERO
var drag_original_position := Vector2.ZERO
var original_z := 0

@export var _cost_text_path: NodePath
@onready var cost_text = get_node(_cost_text_path)
@export var _title_text_path: NodePath
@onready var title_text = get_node(_title_text_path)
@export var _type_text_path: NodePath
@onready var type_text = get_node(_type_text_path)
@export var _card_art_texture_path: NodePath
@onready var card_art_texture = get_node(_card_art_texture_path)
@export var _highlight_path: NodePath
@onready var highlight = get_node(_highlight_path)

@export var hover_vertical_offset : float
@onready var hover_offset := Vector2(0, -hover_vertical_offset)
@onready var selected_offset := Vector2(0, -hover_vertical_offset * 1.5)
var hover_base_position := Vector2.ZERO
var hover_tween: Tween

var return_to_hand_tween: Tween

var card_logic: Card

var can_drag: bool = true
var can_hover: bool = true
var is_in_drop_zone: bool = false

@export var _arc_path: NodePath
@onready var arc = get_node(_arc_path) 
const ARC_POINTS := 8

const DRAG_ZONE_DISTANCE := 30

var context : BattleContext

var current_card_state : CardUIState
@onready var idle_state : CardUIIdleState = CardUIIdleState.new(self)
@onready var hover_state : CardUIHoverState = CardUIHoverState.new(self)
@onready var drag_state : CardUIDragState = CardUIDragState.new(self)
@onready var return_state : CardUIReturnState = CardUIReturnState.new(self)
@onready var play_process_state : CardUIPlayProcessState = CardUIPlayProcessState.new(self)
@onready var selected_state : CardUISelectedState = CardUISelectedState.new(self)

# TEMP TBD: Make tooltip logic recursive
@export var _tooltip_path: NodePath
@onready var tooltip = get_node(_tooltip_path)

@onready var tooltip_offset = Vector2(0, -103)
@onready var tooltip_base_offset = Vector2(3, 5)
@export var _tooltip_text_path: NodePath
@onready var tooltip_text_label = get_node(_tooltip_text_path)
var tooltip_tween : Tween

var mouse_on : bool
var input_type : HandUI.InputType = HandUI.InputType.BATTLE

signal drag_started(card)
signal drag_ended(card)
signal selection_started(card)
signal selection_ended(card)
signal hover_started(card)
signal hover_ended(card)
signal attempt_card_play(cardGUI, cardLogic)
signal entered_drop_zone(card)
signal exited_drop_zone(card)

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	hover_base_position = global_position
	drag_original_position = global_position
	
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)
	
	is_in_drop_zone = false
	
	hide_tooltip()
	
	change_state(idle_state)
	# pivot_offset = size / 2
	
func _process(_delta):
	# constantly update arc. recalc for mouse pos
	
	if current_card_state == drag_state and card_logic.target_drag:		
		arc.visible = true
		arc.points = _get_points()
		
		if context.get_hovered_enemy():
			arc.default_color = Color.RED
		else:
			arc.default_color = Color.WHITE
	elif current_card_state == drag_state:
		var distance = global_position.distance_to(drag_original_position)
	
		if is_in_drop_zone && distance < DRAG_ZONE_DISTANCE:
			is_in_drop_zone = false
			exited_drop_zone.emit(card_logic)
		elif not is_in_drop_zone && distance >= DRAG_ZONE_DISTANCE:
			is_in_drop_zone = true
			entered_drop_zone.emit(card_logic)
		arc.visible = false
	else:
		arc.visible = false
		
func change_state(state : CardUIState):
	if current_card_state:
		current_card_state.exit()
	current_card_state = state
	
	# print(state == drag_state)
	
	current_card_state.enter()		

# Detect Drag
func _gui_input(event):
	current_card_state.gui_input(event)

		
func update_card_logic(card: Card) -> void:
	card_logic = card
	
	cost_text.text = str(card.cost)
	title_text.text = card.title
	type_text.text = Card.get_card_type_as_string(card.type)
	card_art_texture.texture = card.texture
	
	var desc = KeywordFormatter.format_text(card_logic.description)
	
	tooltip_text_label.text = desc
	
	change_state(idle_state)
		
# Makes card hover when highlighting
func _on_mouse_enter():
	mouse_on = true
	current_card_state.mouse_entered()

func _on_mouse_exit():
	mouse_on = false
	current_card_state.mouse_exited()
	
func emit_hover_started():
	hover_started.emit(card_logic)
	
func emit_hover_ended():
	hover_ended.emit(card_logic)
	
func emit_drag_started():
	drag_started.emit(card_logic)

func emit_drag_ended():
	drag_ended.emit(card_logic)
	
func emit_selection_started():
	selection_started.emit(card_logic)
	
func emit_selection_ended():
	selection_ended.emit(card_logic)
	
func start_hover_tween():
	if (return_to_hand_tween):
		return_to_hand_tween.kill()
	
	if hover_tween:
		hover_tween.kill()
	
	# Tweens position up
	hover_tween = create_tween()
	hover_tween.tween_property(self, "global_position", hover_base_position + hover_offset, 0.12)\
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
func start_hover_reverse_tween():
	if hover_tween:
		hover_tween.kill()
	
	# Tweens position down
	hover_tween = create_tween()
	hover_tween.tween_property(self, "global_position", hover_base_position, 0.12)\
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func start_drag(mouse_pos):
	if hover_tween:
		hover_tween.kill()
		
	drag_offset = mouse_pos - global_position
	global_position = hover_base_position + hover_offset

	drag_original_position = global_position - hover_offset
	
	#z_index = 1000 # front layer TBD
	
	is_in_drop_zone = false
	exited_drop_zone.emit(card_logic)

func request_attempt_card_play():
	attempt_card_play.emit(self, card_logic)

func end_drag():
	if hover_tween:
		hover_tween.kill()
	
	# z_index = 0
	is_in_drop_zone = false
	exited_drop_zone.emit(card_logic)
	
func force_end_drag():
	if hover_tween:
		hover_tween.kill()
	
	#dragging = false
	drag_ended.emit(card_logic)
	z_index = 0
	is_in_drop_zone = false
	exited_drop_zone.emit(card_logic)
	
func drag(mouse_position):
	# targetable card stay in hand and draws and arrow
	if card_logic.target_drag:
		global_position = drag_original_position + hover_offset
	else:
		global_position = mouse_position - drag_offset
	
func return_to_hand():
	change_state(return_state)
	
func tween_to_hand():
	if (return_to_hand_tween):
		return_to_hand_tween.kill()
	
	return_to_hand_tween = create_tween()
	
	return_to_hand_tween.tween_property(self, "global_position", drag_original_position, 0.15)\
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	hover_base_position = drag_original_position
	
	z_index = original_z
	
func tween_to_selected():
	if (return_to_hand_tween):
		return_to_hand_tween.kill()
		
	if hover_tween:
		hover_tween.kill()
	
	# Tweens position up
	return_to_hand_tween = create_tween()
	return_to_hand_tween.tween_property(self, "global_position", hover_base_position + selected_offset, 0.12)\
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

# Arc Maths for drawing arrow
func _get_points() -> Array:
	var start : Vector2 = size / 2 + Vector2(0, -size.y/2)
	var end : Vector2 = get_global_mouse_position() - global_position
	
	var left_bound = -193 - global_position.x
	var right_bound = 193 - global_position.x
	end.x = clamp(end.x, left_bound, right_bound)
	var top_bound = -100 - global_position.y
	var bottom_bound = 0
	end.y = clamp(end.y, top_bound, bottom_bound)
	
	var points := []
	var distance := (end - start)
	for i in ARC_POINTS:
		var t := (1.0 / ARC_POINTS) * i
		var x := start.x + (distance.x / ARC_POINTS) * i
		var y := start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x, y))
	points.append(end)
	return points

func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)

func show_tooltip():
	if tooltip_tween:
		tooltip_tween.kill()
		
	tooltip.global_position = hover_base_position + tooltip_base_offset	
		
	tooltip_tween = create_tween()
	tooltip_tween.tween_property(tooltip, "global_position", hover_base_position + tooltip_base_offset + tooltip_offset, 0.12)\
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
	tooltip.visible = true	
	
func hide_tooltip():
	if tooltip_tween:
		tooltip_tween.kill()
		
	tooltip.visible = false	
	tooltip.global_position = hover_base_position + tooltip_base_offset
	
func show_highlight():
	highlight.visible = true
func hide_highlight():
	highlight.visible = false
