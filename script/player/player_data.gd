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
var attributes : Dictionary

func has_item_capacity() -> bool:
	return items.size() < max_items

func update_attributes():
	for item in items:
		for attribute in item["SCALING"]:
			if not attributes.has(attribute):
				attributes[attribute] = item["SCALING"][attribute]
			else:
				attributes[attribute] += item["SCALING"][attribute]
	for attribute in weapon["SCALING"]:
		if not attributes.has(attribute):
			attributes[attribute] = weapon["SCALING"][attribute]
		else:
			attributes[attribute] += weapon["SCALING"][attribute]
