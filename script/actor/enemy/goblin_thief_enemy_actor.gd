class_name GoblinThiefEnemyActor
extends EnemyActor

var fixed_speed_temp = 99
var id : String = "goblin_thief_enemy"

var gold_taken : int = 0

func _init(data):
	super._init(data)
	
	moveset.add_move(AttackActorPremove.new(40, id, self))
	moveset.add_move(AttackActorPremove.new(50, id, self))
	moveset.add_move(MultiAttackActorPremove.new(30, 2, id, self))
	moveset.add_move(DefendActorPremove.new(60, self))
	moveset.add_move(EscapeActorPremove.new(1, self))
	
func on_battle_join(controller, context):
	var effect = ThievingStatusEffect.new("thieving_status", 5)

	var ctx : StatusEffectApplicationContext = StatusEffectApplicationContext.new(self, 
		effect, id)
	controller.apply_status(ctx)
	
func _on_gold_taken(amount : int):
	gold_taken += amount

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Goblin Thief"
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
