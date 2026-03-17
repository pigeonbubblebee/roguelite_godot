class_name ArmorResetContext
extends RefCounted

var actor: Actor
var amount: int

var armor_gained : int = 0

var amount_reduction = 0

func _init(_actor, _amount):
	actor = _actor
	amount = _amount

func calculate_final() -> int:
	return max(0,amount - (amount - amount_reduction))
