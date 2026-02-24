class_name PlayerActor
extends Actor

var fixed_speed_temp = 201

# RUNTIME ATTRIBUTES
var strength: int
var dexterity: int
var intelligence: int
var vigor: int
var defense: int
var arcane: int

func get_speed() -> float:
	return fixed_speed_temp

func take_action() -> void:
	print("Player Turn Taken")

func get_actor_name() -> String:
	return "Player"
	
func get_actor_faction() -> Faction.Type:
	return Faction.Type.ALLY
