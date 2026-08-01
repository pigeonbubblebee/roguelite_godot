class_name GreaterDeathbirdEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var wound_amount : int = 3
var wound_id : String = "deaths_call_card"
var status_id_buff : String = "might_status"
var status_id_debuff : String = "weakened_status"
var debuff_stacks : int = 2
var might_stacks : int = 2

var id : String = "greater_deathbird_enemy"

func _init(data):
	super._init(data)
	
	moveset.add_move(DebuffActorPremove.new(debuff_stacks, id, self,
		func(t): 
				return DamageAmplificationStatusEffect.new(status_id_debuff, 
				debuff_stacks, DamageAmplificationStatusEffect.weakened_percent_bonus)))
	moveset.add_move(MultiAttackActorPremove.new(40, 2, id, self))
	moveset.add_move(MultiAttackActorPremove.new(10, 3, id, self))
	moveset.add_move(CompositeActorPremove.new(self, [
		ShuffleWoundPremove.new(wound_amount, wound_id, self),
		BuffActorPremove.new(might_stacks, id, self,
		func(t): 
				return FlatDamageBonusStatusEffect.new(status_id_buff, 
				might_stacks))
		])
	)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Greater Deathbird"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
