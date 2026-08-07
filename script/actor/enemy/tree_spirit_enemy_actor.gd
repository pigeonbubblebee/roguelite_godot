class_name TreeSpiritEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var wound_amount : int = 1
var wound_id : String = "rot_card"

var status_id = "weakened_status"
var status_turns : int = 2

var id : String = "tree_spirit"

func _init(data):
	super._init(data)
	
	moveset.add_first_move(ShuffleWoundPremove.new(3, wound_id, self))
	moveset.add_move(AttackActorPremove.new(110, id, self))
	moveset.add_move(DefendActorPremove.new(100, self))
	moveset.add_move (DebuffActorPremove.new(status_turns, id, self,
		func(t): 
				return DamageAmplificationStatusEffect.new(status_id, 
				status_turns, DamageAmplificationStatusEffect.weakened_percent_bonus)))

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Rotting Tree Spirit"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
