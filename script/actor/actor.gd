class_name Actor
extends RefCounted

# AV -> Action Value (Remaining time to act)
var _remaining_av: float

var actor_data: ActorData
var status_effect_manager: ActorStatusEffectManager

var _team_position : int

var _health : int
var _armor : int

signal health_updated
signal damage_taken(dmg, ctx)
signal armor_updated(armor)
signal died(actor: Actor)
signal armor_gained(amount)

var _processing_death = false

func _init(data: ActorData):
	actor_data = data
	status_effect_manager = ActorStatusEffectManager.new()

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
func take_action(context: BattleContext, controller: BattleController) -> void:
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
	var taken_damage = damage
	
	if has_armor():
		_armor -= damage
		taken_damage = 0
		
		if _armor < 0:
			taken_damage = _armor * -1
			_armor = 0
			
		armor_updated.emit(_armor)
	
	_health -= taken_damage
	# print(actor_data.name + " HIT! DAMAGE: " + str(damage) + ", HEALTH: " + str(_health))
	emit_signal("health_updated")
	damage_taken.emit(damage, context)

func request_death():
	if not _processing_death:
		died.emit(self)
		
	_processing_death = true

	
func reset_health():
	_health = actor_data.max_health
	emit_signal("health_updated")
	
func get_max_health():
	return actor_data.max_health
	
func get_health():
	return _health
func get_armor():
	return _armor
	
func add_armor(amt: int):
	_armor += amt
	armor_updated.emit(_armor)
	armor_gained.emit(amt)
	
func reset_armor():
	_armor = 0
	armor_updated.emit(_armor)
	
func has_armor() -> bool:
	return _armor > 0

func apply_status(status, context, controller):
	status_effect_manager.apply_status(status, context, controller)

func get_status_manager() -> ActorStatusEffectManager:
	return status_effect_manager
