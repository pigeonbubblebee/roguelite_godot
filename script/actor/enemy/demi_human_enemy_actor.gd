class_name DemiHumanEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var moveset := ActorCycleMoveset.new()

var status_id : String = "vulnerable_status"
var status_turns : int = 3

func _init(data):
	super._init(data)
	
	moveset.add_move((DebuffActorPremove.new(status_turns, "demi_human_enemy", self,
		func(t): 
				return DamageTakenAmplificationStatusEffect.new(status_id, 
				status_turns)))
	)
	moveset.add_move(AttackActorPremove.new(60, "demi_human_enemy", self))
	moveset.add_move(ArmorAttackActorPremove.new(40, "demi_human_enemy", self, 40))

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Demi-Human"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
