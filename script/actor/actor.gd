class_name Actor
extends RefCounted

# AV -> Action Value (Remaining time to act)
var _remaining_av: float

var actor_data: ActorData

var battle_context: BattleContext

var _team_position : int

var _health : int
signal health_updated
signal damage_taken(dmg, ctx)
signal died(actor: Actor)
var _processing_death = false

func _init(data: ActorData):
	actor_data = data
	
func reset_health():
	_health = actor_data.max_health
	emit_signal("health_updated")

# Getter & setter for remaining AV
func get_remaining_av() -> float:
	return _remaining_av
func set_remaining_av(av: float):
	_remaining_av = av

# Implementable function for speed
func get_speed() -> float:
	push_error("get_speed() must be implemented by subclasses")
	return 0.0
	
# Implementable function for taking action
func take_action() -> void:
	push_error("take_action() must be implemented by subclasses")
	
# Implementable function for getting actor name
func get_actor_name() -> String:
	push_error("get_name() must be implemented by subclasses")
	return "Unnamed"
	
func get_actor_faction() -> Faction.Type:
	push_error("get_actor_faction() must be implemented by subclasses")
	return Faction.Type.ALLY
	
func get_texture() -> Texture2D:
	return actor_data.icon_texture

func set_team_position(position: int) -> void:
	_team_position	= position
	
func get_team_position() -> int:
	return _team_position	

func take_damage(damage: int, context: DamageContext) -> void:
	_health -= damage
	# print(actor_data.name + " HIT! DAMAGE: " + str(damage) + ", HEALTH: " + str(_health))
	emit_signal("health_updated")
	damage_taken.emit(damage, context)

func request_death():
	if not _processing_death:
		died.emit(self)
		
	_processing_death = true
