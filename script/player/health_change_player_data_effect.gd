class_name HealthChangePlayerDataEffect
extends PlayerDataEffect

var amount : int

func _init(health : int):
	amount = health

func apply(player_data : PlayerData):
	player_data.health = amount
