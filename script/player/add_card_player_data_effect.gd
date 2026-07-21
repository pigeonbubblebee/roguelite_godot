class_name AddCardPlayerDataEffect
extends PlayerDataEffect

var card_id

func _init(card : String):
	card_id = card

func apply(player_data : PlayerData):
	player_data.deck.append(CardDatabase.get_card(card_id))
