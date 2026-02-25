class_name HandUI
extends Control

@export var card_ui_scene: PackedScene
var cards_ui_array: Array[Control] = []
@export var _card_ui_container_path: NodePath
@onready var card_ui_container = get_node(_card_ui_container_path)
@export var _card_starting_position_path: NodePath
@onready var card_starting_position = get_node(_card_starting_position_path)

@export var spacing : int

var dragged_card: Card
var hovered_card: Card

var context : BattleContext

signal card_drag_started(card)
signal card_drag_ended(card)

signal card_hover_started(card)
signal card_hover_ended(card)

signal card_entered_drop_zone(card)
signal card_exited_drop_zone(card)

signal card_ui_play_request(cardGUI, card_logic)

func bind(controller: BattleController):
	context = controller.get_context()
	var hand_manager = controller.get_hand_manager()
	
	controller.turn_started.connect(_on_turn_started)
	# connect signal to update action bar
	
	hand_manager.connect("hand_updated", Callable(self, "update_ui"))
	update_ui(hand_manager.get_hand()) 

func update_ui(hand: Array[Card]):

	# Adds excess cards if new card in hand
	for i in range(hand.size()):
		if i >= cards_ui_array.size():
			var card = card_ui_scene.instantiate()
			card_ui_container.add_child(card)
			cards_ui_array.append(card)
			
			card.context = context
			#card.ui_manager = self
			
			card.drag_started.connect(_on_card_drag_started)
			card.drag_ended.connect(_on_card_drag_ended)
			
			card.hover_started.connect(_on_card_hover_started)
			card.hover_ended.connect(_on_card_hover_ended)
			
			card.entered_drop_zone.connect(_on_card_entered_drop_zone)
			card.exited_drop_zone.connect(_on_card_exited_drop_zone)
			
			card.attempt_card_play.connect(_on_card_attempt_card_play)
			
			# card.card_played.connect(_on_card_played)
			# card.hover_base_position = card.position
			
	for i in range(cards_ui_array.size()):
		if i >= hand.size():
			var card_ui = cards_ui_array[i]
			cards_ui_array.remove_at(i)
			card_ui.queue_free()

	# Updates all actors
	for i in range(hand.size()):
		var card_logic = hand[i]
		var ui = cards_ui_array[i]
		# print(card_logic)
		ui.update_card_logic(card_logic)

	layout_hand()

func set_context(context: BattleContext):
	self.context = context
	for card in cards_ui_array:
		card.context = context
		
func layout_hand():
	var base_z = 1
	#var start_x = -((cards_ui_array.size() - 1) * spacing) / 2
	var start_x = card_starting_position.global_position.x
	var start_y = card_starting_position.global_position.y
	var fan_curve_strength : float = 0
	
	var middle_index = (cards_ui_array.size() - 1) / 2.0
	
	var max_width = 280
	var card_spacing = min(spacing, max_width / max(cards_ui_array.size(), 1))
	
	for i in cards_ui_array.size():
		var card = cards_ui_array[i]
		var offset = i - middle_index
		var x_offset = offset * card_spacing - card.size.x/2
		var y_offset = pow(offset, 2) * card_spacing * fan_curve_strength
		
		card.hover_base_position = Vector2(start_x + x_offset, start_y + y_offset)
		card.drag_original_position = card.hover_base_position
		card.global_position = card.hover_base_position

func _on_card_drag_started(card):
	dragged_card = card
	
	for cardGUI in cards_ui_array:
		cardGUI.can_hover = false
	
	card_drag_started.emit(card)

func _on_card_drag_ended(card):
	dragged_card = null
	
	for cardGUI in cards_ui_array:
		cardGUI.can_hover = true
	
	card_drag_ended.emit(card)
	
func _on_card_hover_started(card):
	hovered_card = card
	card_hover_started.emit(card)

func _on_card_hover_ended(card):
	if hovered_card == card:
		hovered_card = null
	card_hover_ended.emit(card)
	
func _on_card_entered_drop_zone(card):
	card_entered_drop_zone.emit(card)

func _on_card_exited_drop_zone(card):
	card_exited_drop_zone.emit(card)
	
func _on_card_attempt_card_play(cardGUI: CardGUI, logic: Card):
	card_ui_play_request.emit(cardGUI, logic)
	
func on_action_queue_started():
	for card_ui in cards_ui_array:
		card_ui.can_drag = false
		
		if(card_ui.current_card_state == card_ui.drag_state):
			card_ui.current_card_state.force_drag_end()
		
func on_action_queue_finished():
	for card_ui in cards_ui_array:
		card_ui.can_drag = true
		
func _on_turn_started(actor : Actor):
	if actor.get_actor_name() == "Player":
		for card_ui in cards_ui_array:
			card_ui.can_drag = true
		return
	for card_ui in cards_ui_array:
		card_ui.can_drag = false
		
		if(card_ui.current_card_state == card_ui.drag_state):
			card_ui.current_card_state.force_drag_end()
