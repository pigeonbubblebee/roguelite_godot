class_name GoblinArcherEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var moveset := ActorCycleMoveset.new()

var status_id = "weakened_status"
var status_turns : int = 2

func _init(data):
	super._init(data)
	
	var first_move = (DebuffActorPremove.new(status_turns, "goblin_enemy", self,
		func(t): 
				return DamageAmplificationStatusEffect.new(status_id, 
				status_turns, DamageAmplificationStatusEffect.weakened_percent_bonus)))
	moveset.add_first_move(first_move)		
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
