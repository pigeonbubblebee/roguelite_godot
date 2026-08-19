class_name OrcCaptainEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var id : String = "orc_captain_enemy"

var status_id_buff : String = "empowered_status"
var status_stacks : int = 3
var status_id_debuff_one : String = "weakened_status"
var status_id_debuff_two : String = "unsteady_status"
var debuff_stacks : int = 1

func _init(data):
	super._init(data)

	moveset.add_move(CompositeActorPremove.new(self, [
		DebuffActorPremove.new(
			debuff_stacks,
			id,
			self,
			func(t): 
				return DamageAmplificationStatusEffect.new(status_id_debuff_one, 
				debuff_stacks, DamageAmplificationStatusEffect.weakened_percent_bonus)),
		DebuffActorPremove.new(
			debuff_stacks,
			id,
			self,
			func(t): 
				return ArmorAmplificationStatusEffect.new(status_id_debuff_two, 
				debuff_stacks, ArmorAmplificationStatusEffect.unsteady_percent_bonus))
		])
	)
	moveset.add_move(ArmorAttackActorPremove.new(50, id, self, 59))
	
	var buff_move : BuffActorPremove = (BuffActorPremove.new(status_stacks, id, self,
		func(t): 
				return DamageAmplificationStatusEffect.new(status_id_buff, status_stacks)))
	buff_move.target_mode = BuffActorPremove.target_mode_group
	
	moveset.add_move(buff_move)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Orc Captain"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
