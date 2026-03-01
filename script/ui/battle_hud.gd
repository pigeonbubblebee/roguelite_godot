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

@export var _actor_label_path: NodePath
@onready var actor_label = get_node(_actor_label_path)

var _currently_connected_actor : Actor

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
	return
	#card_label.text = "No card selected"
	
func on_energy_change(amt: int):
	energy_label.text = str(amt)
	energy_label_2.text = str(amt)

func on_deck_change(deck):
	deck_count_label.text = "Deck: " + str(deck.size()) 
func on_discard_change(discard):
	discard_count_label.text = "Discard: " + str(discard.size()) 

func on_hovered_actor_change(actor: ActorUI):
	if actor:
		_currently_connected_actor = actor.actor
		connect_actor_to_hud(_currently_connected_actor)
	else:
		disconnect_actor_from_hud(_currently_connected_actor)

func connect_actor_to_hud(actor: Actor):
	actor.armor_gained.connect(update_actor_hud_info)
	actor.health_updated.connect(update_actor_hud_info)
	actor.get_status_manager().status_updated.connect(update_actor_hud_info)
	
	update_actor_hud_info()
	#actor.health_updated.connect(update_actor_hud_info)
	
func disconnect_actor_from_hud(actor: Actor):
	actor.armor_gained.disconnect(update_actor_hud_info)
	actor.health_updated.disconnect(update_actor_hud_info)
	actor.get_status_manager().status_updated.disconnect(update_actor_hud_info)
	actor_label.text = "No Enemy Selected"
	
func update_actor_hud_info(armor = 0):
	var hp_text = "HP: " + str(_currently_connected_actor.get_health()) + "/" + str(_currently_connected_actor.get_max_health())
	var ar_text = "ARMOR: " + str(_currently_connected_actor.get_armor())
	var sp_text = "SPD: " + "%.2f" % (_currently_connected_actor.get_speed())
	
	var status_text = "\n"
	var active_status = _currently_connected_actor.get_status_manager().get_active_status()
	
	if active_status.size() > 0:
		status_text += "Status Effects:\n"
	
	for status in active_status:
		var stack_text = ("x" + str(status.get_stacks())) if not status.get_is_turn_based() else (str(status.get_stacks()) + " Turns")
		var text = status.get_name() + " (" + stack_text + ")\n"
		
		status_text = status_text + text + "\n"
	
	actor_label.text = _currently_connected_actor.get_actor_name() + ":\n" + hp_text + "\n" + ar_text + "\n" + sp_text + "\n" + status_text
