class_name RunebearEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var status_id_buff : String = "might_status"
var status_id_debuff : String = "unsteady_status"
var debuff_stacks : int = 2
var might_stacks : int = 4
var id : String = "runebear_enemy"

func _init(data):
	super._init(data)
	
	moveset.add_move(DebuffActorPremove.new(
			debuff_stacks,
			id,
			self,
			func(t): 
				return ArmorAmplificationStatusEffect.new(status_id_debuff, 
				debuff_stacks, ArmorAmplificationStatusEffect.unsteady_percent_bonus))
	)
	moveset.add_move(ArmorAttackActorPremove.new(110, id, self, 110))
	moveset.add_move(DefendActorPremove.new(210, self))
	moveset.add_move(CompositeActorPremove.new(self, [
		BuffActorPremove.new(might_stacks, id, self,
		func(t): 
				return FlatDamageBonusStatusEffect.new(status_id_buff, 
				might_stacks)),
		DefendActorPremove.new(110, self)
		])
	)
	
func on_battle_join(controller, context):
	var effect = HealingRuneStatusEffect.new("healing_rune_status", 2)
	var ctx : StatusEffectApplicationContext = StatusEffectApplicationContext.new(self, 
		effect, id)
	controller.apply_status(ctx)

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Runebear"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
