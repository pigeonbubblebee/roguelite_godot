class_name DemiHumanChiefEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var moveset := ActorCycleMoveset.new()

var status_id : String = "weakened_status"
var status_turns : int = 2
var id : String = "demi_human_chief_enemy"
var status_id_buff : String = "might_status"
var might_stacks : int = 1

func _init(data):
	super._init(data)
	
	moveset.add_move(DebuffActorPremove.new(status_turns, id, self,
		func(t): 
				return DamageAmplificationStatusEffect.new(status_id, 
				status_turns, DamageAmplificationStatusEffect.weakened_percent_bonus))
	)
	moveset.add_move(AttackActorPremove.new(60, id, self))
	var buff_move : BuffActorPremove = (BuffActorPremove.new(might_stacks, "bear_enemy", self,
		func(t): 
				return FlatDamageBonusStatusEffect.new(status_id_buff, 
				might_stacks)))
	buff_move.target_mode = BuffActorPremove.target_mode_group
	
	moveset.add_move(buff_move)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Demi-Human Chief"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
