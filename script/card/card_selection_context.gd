class_name CardSelectionContext
extends RefCounted

const DISCARD_PROMPT = "Choose a Card to Discard"

var source_cards : Array[Card]
var amount : int
var prompt : String

var selected_cards : Array[Card]

signal finished(selected_cards)

func _init(_cards, _prompt, _amount = 1):
	source_cards = _cards
	prompt = _prompt
	amount = _amount
	
func finish():
	finished.emit(selected_cards)
