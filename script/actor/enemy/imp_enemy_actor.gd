class_name ImpEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var moveset := ActorCycleMoveset.new()

var status_id = "weakened_status"
var status_turns : int = 1

var status_id_buff : String = "might_status"
var might_stacks : int = 1

var id : String = "imp_enemy"

func _init(data):
	super._init(data)
	
	var first_move = (DebuffActorPremove.new(status_turns, id, self,
		func(t): 
				return DamageAmplificationStatusEffect.new(status_id, 
				status_turns, DamageAmplificationStatusEffect.weakened_percent_bonus)))
	moveset.add_first_move(first_move)		
	moveset.add_move(AttackActorPremove.new(30, id, self))
	moveset.add_move(AttackActorPremove.new(30, id, self))
	moveset.add_move((BuffActorPremove.new(might_stacks, id, self,
		func(t): 
				return FlatDamageBonusStatusEffect.new(status_id_buff, 
				might_stacks)))
	)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Imp"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
