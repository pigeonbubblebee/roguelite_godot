class_name ArmorGainContext
extends RefCounted

var actor: Actor
var amount: int
var source

var armor_gained : int = 0

var armor_percent : float = 0

func _init(_actor, _amount, _source = null):
	actor = _actor
	amount = _amount
	source = _source

func add_armor_percent(percent : float):
	armor_percent += percent

func calculate_armor() -> int:
	var float_armor = float(amount)
	
	var final_armor = float_armor * (1 + armor_percent)
	
	return max(0, final_armor)
