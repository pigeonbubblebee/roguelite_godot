class_name GoblinEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var moveset := ActorCycleMoveset.new()

func _init(data):
	super._init(data)
	
	moveset.add_move(AttackActorPremove.new(40, "goblin_enemy", self))
	moveset.add_move(AttackActorPremove.new(50, "goblin_enemy", self))

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Goblin"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
