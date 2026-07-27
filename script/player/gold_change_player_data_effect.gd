class_name GoldChangePlayerDataEffect
extends PlayerDataEffect

var amount : int

func _init(gold : int):
	amount = gold

func apply(player_data : PlayerData):
	player_data.gold += amount
	
	if(player_data.gold <= 0):
		player_data.gold = 0
