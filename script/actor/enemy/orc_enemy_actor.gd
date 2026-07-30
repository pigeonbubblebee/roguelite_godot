class_name OrcEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var wound_amount : int = 1
var wound_id : String = "gash_card"

var id : String = "orc_enemy"

func _init(data):
	super._init(data)
	
	moveset.add_move(AttackActorPremove.new(75, id, self))
	moveset.add_move(ShuffleWoundPremove.new(wound_amount, wound_id, self))
	moveset.add_move(ArmorAttackActorPremove.new(50, id, self, 50))

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Orc"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
