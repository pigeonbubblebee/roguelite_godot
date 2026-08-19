class_name BearEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var status_id_buff : String = "might_status"
var status_id_debuff_one : String = "weakened_status"
var status_id_debuff_two : String = "unsteady_status"
var debuff_stacks : int = 1
var might_stacks : int = 4

func _init(data):
	super._init(data)
	
	moveset.add_move(CompositeActorPremove.new(self, [
		DebuffActorPremove.new(
			debuff_stacks,
			"bear_enemy",
			self,
			func(t): 
				return DamageAmplificationStatusEffect.new(status_id_debuff_one, 
				debuff_stacks, DamageAmplificationStatusEffect.weakened_percent_bonus)),
		DebuffActorPremove.new(
			debuff_stacks,
			"bear_enemy",
			self,
			func(t): 
				return ArmorAmplificationStatusEffect.new(status_id_debuff_two, 
				debuff_stacks, ArmorAmplificationStatusEffect.unsteady_percent_bonus))
		])
	)
	moveset.add_move(AttackActorPremove.new(140, "bear_enemy", self))
	moveset.add_move((BuffActorPremove.new(might_stacks, "bear_enemy", self,
		func(t): 
				return FlatDamageBonusStatusEffect.new(status_id_buff, 
				might_stacks)))
	)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Bear"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
