class_name PlayerData
extends RefCounted

var deck : Array
var health : int
var max_health : int
var gold : int
var keys : int
var weapon : Dictionary
var items : Array
var max_items : int = 4

func has_item_capacity() -> bool:
	return items.size() < max_items
