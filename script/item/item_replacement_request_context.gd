class_name ItemReplacementRequestContext
extends RefCounted

var reward_item: Dictionary
var current_items : Array

func _init(item: Dictionary, current: Array):
	reward_item = item
	current_items = current
