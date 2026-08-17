class_name ShopScene
extends Node

@export var exit_button_path : NodePath
@onready var exit_button = get_node(exit_button_path)

@export var hud_path : NodePath
@onready var hud = get_node(hud_path)

@export var card_view_ui_path : NodePath
@onready var card_view_ui = get_node(card_view_ui_path)
@export var item_view_ui_path : NodePath
@onready var item_view_ui = get_node(item_view_ui_path)
@export var weaoon_view_ui_path : NodePath
@onready var weaoon_view_ui = get_node(weaoon_view_ui_path)

@export var _item_replace_ui_path: NodePath
@onready var _item_replace_ui = get_node(_item_replace_ui_path)

signal exit_requested(finished)
	
var controller : ShopController

func bind_controller(c : ShopController):
	controller = c
	controller.cards_updated.connect(on_cards_updated)
	controller.items_updated.connect(on_items_updated)
	controller.weapons_updated.connect(on_weapons_updated)
	
	on_cards_updated(controller.get_cards()) 
	on_items_updated(controller.get_items())
	on_weapons_updated(controller.get_weapons())
	
	c.reward_handler.reward_interaction_requested.connect(_on_reward_interaction_requested)
	
	# layout_cards()
	
func _ready():
	exit_button.pressed.connect(exit)	
	_item_replace_ui.request_item_replacement.connect(process_item_replace)
	
func bind_game_manager(game_manager: GameManager):
	hud.bind_game_manager(game_manager)

func exit():
	exit_requested.emit()

func on_cards_updated(awards : Array):
	card_view_ui.columns = awards.size()
	
	card_view_ui.INPUT_TYPE = HandUI.InputType.SHOP
	card_view_ui.scrollable = false
	

	card_view_ui.display_cards_from_refcounted(awards)
	
	card_view_ui.visible = true
	

	for card_ui in card_view_ui.cards_ui_array:
		card_ui.show_price(controller.get_price_of_card(card_ui.card_logic))

		if not card_ui.purchase_requested.is_connected(on_purchase_requested_card):
			card_ui.purchase_requested.connect(on_purchase_requested_card)
			
func on_items_updated(awards : Array):
	item_view_ui.columns = awards.size()

	item_view_ui.scrollable = false

	item_view_ui.display_items_from_refcounted(awards)
	
	item_view_ui.visible = true
	
	for item_ui in item_view_ui.item_ui_array:
		item_ui.show_price(controller.get_price_of_item(item_ui.get_item()))
	#	index+=1
		item_ui.can_be_purchased = true
		item_ui.can_be_selected = false
		if not item_ui.purchase_requested.is_connected(on_purchase_requested_item):
			item_ui.purchase_requested.connect(on_purchase_requested_item)
			
func on_weapons_updated(awards : Array):
	weaoon_view_ui.columns = awards.size()

	weaoon_view_ui.scrollable = false

	weaoon_view_ui.display_items_from_refcounted(awards)
	
	weaoon_view_ui.visible = true
	
	for item_ui in weaoon_view_ui.item_ui_array:
		item_ui.show_price(controller.get_price_of_item(item_ui.get_item()))
	#	index+=1
		item_ui.can_be_purchased = true
		item_ui.can_be_selected = false
		if not item_ui.purchase_requested.is_connected(on_purchase_requested_item):
			item_ui.purchase_requested.connect(on_purchase_requested_item)

func on_purchase_requested_card(card: Card):
	controller.request_purchase_card(card)

func on_purchase_requested_item(item: Item):
	controller.request_purchase_item(item)
	
func _on_reward_interaction_requested(request : ItemReplacementRequestContext):
	_item_replace_ui.mouse_filter = _item_replace_ui.MOUSE_FILTER_STOP
	_item_replace_ui.visible = true
	
	_item_replace_ui.init_replace(
		request.current_items,
		request.reward_item
	)

func process_item_replace(slot, item):
	if slot < 0:
		_item_replace_ui.finish_rewards()
		return
	controller.process_item_replace(slot, item)
	_item_replace_ui.finish_rewards()
