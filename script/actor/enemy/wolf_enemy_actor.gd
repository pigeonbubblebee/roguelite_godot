class_name WolfEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

func _init(data):
	super._init(data)
	
	moveset.add_move(AttackActorPremove.new(35, "wolf_enemy", self))
	moveset.add_move(MultiAttackActorPremove.new(20, 2, "wolf_enemy", self))
	moveset.add_move(DefendActorPremove.new(100, self))

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Wolf"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
