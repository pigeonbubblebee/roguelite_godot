class_name KeyChangePlayerDataEffect
extends PlayerDataEffect

var amt

func _init(keys : int):
	amt = keys

func apply(player_data : PlayerData):
	player_data.keys += amt
