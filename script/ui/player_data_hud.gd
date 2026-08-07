class_name PlayerDataHUD
extends Control

@export var hp_label_path : NodePath
@onready var hp_label = get_node(hp_label_path)
@export var gold_label_path : NodePath
@onready var gold_label = get_node(gold_label_path)
@export var key_label_path : NodePath
@onready var key_label = get_node(key_label_path)

@export var deck_view_ui_path : NodePath
@onready var deck_view_ui = get_node(deck_view_ui_path)
@export var deck_view_path : NodePath
@onready var deck_view = get_node(deck_view_path)
@export var view_deck_button_path : NodePath
@onready var view_deck_button = get_node(view_deck_button_path)
@export var view_deck_button_label_path : NodePath
@onready var view_deck_button_label = get_node(view_deck_button_label_path)

func _ready():
	view_deck_button.pressed.connect(open_deck_view)
	
func bind_game_manager(game_manager: GameManager):
	var player_data = game_manager.player_data
	game_manager.player_data_updated.connect(update_hud)
	update_hud(player_data)
	
func open_deck_view():
	if not deck_view_ui.visible:
		deck_view_ui.visible = true
		view_deck_button_label.text = "Close Deck"
	else:
		deck_view_ui.visible = false
		view_deck_button_label.text = "View Deck"

func update_hud(player_data):
	deck_view.clear_ui()
	deck_view.display_cards(player_data.deck)
	hp_label.text = "HP: %s/%s" % [player_data.health, player_data.max_health]
	gold_label.text = "GOLD: %s" % [player_data.gold]
	key_label.text = "KEYS: %s" % [player_data.keys]
