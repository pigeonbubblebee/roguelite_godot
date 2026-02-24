extends Control

@export var _turn_order_path: NodePath
@onready var turn_order = get_node(_turn_order_path)

@export var _card_label_path: NodePath
@onready var card_label = get_node(_card_label_path)

@export var _energy_label_path: NodePath
@onready var energy_label = get_node(_energy_label_path)
@export var _energy_label_2_path: NodePath
@onready var energy_label_2 = get_node(_energy_label_2_path)

@export var _deck_count_label_path: NodePath
@onready var deck_count_label = get_node(_deck_count_label_path)
@export var _discard_count_label_path: NodePath
@onready var discard_count_label = get_node(_discard_count_label_path)

@export var _attribute_label_path: NodePath
@onready var attribute_label = get_node(_attribute_label_path)
@export var _attribute_label_2_path: NodePath
@onready var attribute_label_2 = get_node(_attribute_label_2_path)

func bind(controller: BattleController):
	turn_order.bind(controller.get_turn_manager())
	controller.get_energy_manager().energy_change.connect(on_energy_change)
	controller.get_hand_manager().deck_updated.connect(on_deck_change)
	controller.get_hand_manager().discard_pile_updated.connect(on_discard_change)
	
	on_energy_change(controller.get_energy_manager().energy)
	on_deck_change(controller.get_hand_manager().deck)
	on_discard_change(controller.get_hand_manager().discard_pile)
	
	attribute_label.text = KeywordFormatter.format_text(attribute_label.text)
	attribute_label_2.text = KeywordFormatter.format_text(attribute_label_2.text)

func on_card_hover_started(card: Card):
	var desc = KeywordFormatter.format_text(card.description)
	card_label.text = card.title + ":\n" + desc
	
func on_card_hover_ended(card: Card):
	card_label.text = "No card selected"

func on_card_drag_ended(card: Card):
	card_label.text = "No card selected"
	
func on_energy_change(amt: int):
	energy_label.text = str(amt)
	energy_label_2.text = str(amt)

func on_deck_change(deck):
	deck_count_label.text = "Deck: " + str(deck.size()) 
func on_discard_change(discard):
	discard_count_label.text = "Discard: " + str(discard.size()) 
