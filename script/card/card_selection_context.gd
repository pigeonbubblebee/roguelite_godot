class_name CardSelectionContext
extends RefCounted

const DISCARD_PROMPT = "Choose {AMOUNT} Card{S} to Discard"
const SHARPEN_PROMPT = "Choose {AMOUNT} Card{S} to Sharpen"
const CARD_REWARD_PROMPT = "Choose a Card to Add to Your Deck"

var source_cards : Array[Card]
var original_cards : Array[Card]
var amount : int
var prompt : String

var selected_cards : Array[Card]

signal finished(selected_cards)

func _init(_cards, _prompt, _amount = 1):
	source_cards = _cards
	prompt = _prompt
	amount = _amount
	
	if source_cards.size() < amount:
		amount = source_cards.size()
	
func get_prompt() -> String:
	var result := prompt
	
	result = result.replace("{AMOUNT}", str(amount))
	result = result.replace("{S}", "" if amount == 1 else "s")
	
	return result
	
func finish():
	finished.emit(selected_cards)
