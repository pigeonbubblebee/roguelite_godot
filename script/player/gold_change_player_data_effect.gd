class_name GoldChangePlayerDataEffect
extends PlayerDataEffect

var amount : int

func _init(gold : int):
	amount = gold

func apply(player_data : PlayerData):
	player_data.gold += amount
