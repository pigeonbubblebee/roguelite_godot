class_name BirdlingEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var moveset := ActorCycleMoveset.new()

var wound_amount : int = 1
var wound_id : String = "deaths_call_card"

func _init(data):
	super._init(data)
	
	moveset.add_move(ShuffleWoundPremove.new(1, wound_id, self))
	moveset.add_move(AttackActorPremove.new(60, "birdling_enemy", self))
	moveset.add_move(AttackActorPremove.new(60, "birdling_enemy", self))

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Lesser Birdling"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
