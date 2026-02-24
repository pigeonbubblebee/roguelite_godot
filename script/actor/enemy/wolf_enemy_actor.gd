class_name WolfEnemyActor
extends EnemyActor

var fixed_speed_temp = 66.6666667

var damage = 50

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Wolf"

func generate_next_move(context: BattleContext):
	next_move = AttackActorPremove.new(50, "wolf_enemy", self)
	move_updated.emit(next_move)
