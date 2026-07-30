class_name OrcVanguardEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var id : String = "orc_vanguard_enemy"

var status_id_buff : String = "might_status"
var might_stacks : int = 2

func _init(data):
	super._init(data)

	moveset.add_move(AttackActorPremove.new(70, id, self))
	moveset.add_move(ArmorAttackActorPremove.new(40, id, self, 40))
	moveset.add_move((BuffActorPremove.new(might_stacks, id, self,
		func(t): 
				return FlatDamageBonusStatusEffect.new(status_id_buff, 
				might_stacks)))
	)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Orc Vanguard"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
