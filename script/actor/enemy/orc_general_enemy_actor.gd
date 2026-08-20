extends EnemyActor

var fixed_speed_temp = 99

var wound_amount : int = 2
var wound_id : String = "gash_card"

var id : String = "orc_general_enemy"

var status_id_debuff_one : String = "weakened_status"
var status_id_debuff_two : String = "unsteady_status"
var debuff_stacks : int = 1

func _init(data):
	super._init(data)
	
	moveset.add_move(AttackActorPremove.new(170, id, self))
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
				debuff_stacks, ArmorAmplificationStatusEffect.unsteady_percent_bonus)),
		ShuffleWoundPremove.new(wound_amount, wound_id, self)
		])
	)
	moveset.add_move(ArmorAttackActorPremove.new(100, id, self, 100))

func on_battle_join(controller, context):
	var effect = GrievousWoundsEffect.new("grievous_wounds_status", 1)
	var ctx : StatusEffectApplicationContext = StatusEffectApplicationContext.new(self, 
		effect, id)
	controller.apply_status(ctx)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "General Borbsnop"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
