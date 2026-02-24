class_name HandManager
extends Node2D

var hand: Array[Card] = []
var deck: Array[Card] = []
var discard_pile: Array[Card] = []

var max_hand_size = 5

signal hand_updated(hand: Array[Card])
signal deck_updated(deck: Array[Card])
signal discard_pile_updated(discard: Array[Card])
signal card_drawn(card: Card)

func _input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_D:
		print("Debug: drawing card!")
		draw_from_top()


func _ready() -> void:
	#EventBus.turn_start.connect(_on_turn_start)
	pass
	
func draw_to_max():
	var card_count = max_hand_size - hand.size()
	if card_count < 0:
		card_count = 0
	draw_from_top(card_count)

func draw_from_top(amt = 1):
	for i in range(amt):
		if deck.is_empty():
			return_all_from_discard()
			
		# Deck still empty after looping discard pile
		if deck.is_empty():
			return	
		
		var card = deck.pop_front()
		draw_card(card)
		#print(card)
	deck_updated.emit(deck)
	
func shuffle_deck():
	deck.shuffle()
	
func add_to_deck(card: CardResource, amt=1):
	for i in range(amt):
		add_card_to_deck(card.logic.new(card))
		
func add_card_to_deck(card: Card):
	deck.append(card)
	
	deck_updated.emit(deck)

func draw_card(card: Card):
	hand.append(card)
	hand_updated.emit(hand)
	card_drawn.emit(card)

func get_hand() -> Array[Card]:
	return hand
	
func discard_card_from_play(card: Card):
	# print(hand.find(card))
	hand.erase(card)
	hand_updated.emit(hand)
	
	discard_pile.append(card)
	discard_pile_updated.emit(discard_pile)

func return_all_from_discard():
	for card in discard_pile:
		add_card_to_deck(card)
		
	shuffle_deck()
		
	discard_pile.clear()
	discard_pile_updated.emit(discard_pile)
