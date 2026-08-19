class_name RemoveCardPlayerDataEffect
extends PlayerDataEffect

var index : int

func _init(_index : int):
	index = _index

func apply(player_data : PlayerData):
	if index > player_data.deck.size():
		push_warning("Index exceeds player deck size")
		return
	player_data.deck.remove_at(index)
