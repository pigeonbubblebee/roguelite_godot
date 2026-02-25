class_name WolfEnemyActor
extends EnemyActor

var fixed_speed_temp = 66.6666667

var damage = 50

var moveset := ActorWeightedMoveset.new()

func _init(data):
	super._init(data)
	
	moveset.add_move(AttackActorPremove.new(45, "wolf_enemy", self), 0.25)
	moveset.add_move(AttackActorPremove.new(30, "wolf_enemy", self), 0.5)
	moveset.add_move(DefendActorPremove.new(60, self), 0.5)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Wolf"

func generate_next_move(context: BattleContext):
	next_move = moveset.get_weighted_move()
	move_updated.emit(next_move)
