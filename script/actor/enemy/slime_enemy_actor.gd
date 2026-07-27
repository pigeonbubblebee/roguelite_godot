class_name SlimeActor
extends EnemyActor

var fixed_speed_temp = 99

var moveset := ActorCycleMoveset.new()

var status_id = "weakened_status"
var status_turns : int = 2

var wound_amount : int = 1
var wound_id : String = "gash_card"

var id : String = "slime_enemy"

var split_enemy_resource : ActorData = preload("res://data/enemy/slime_small_enemy.tres")

func _init(data):
	super._init(data)
	
	health_updated.connect(check_split)
	
	moveset.add_move(DebuffActorPremove.new(status_turns, id, self,
		func(t): 
				return DamageAmplificationStatusEffect.new(status_id, 
				status_turns, DamageAmplificationStatusEffect.weakened_percent_bonus)))
	moveset.add_move(AttackActorPremove.new(60, id, self))
	moveset.add_move(ShuffleWoundPremove.new(wound_amount, wound_id, self))

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Slime"
	
func on_battle_join(controller, context):
	var effect = FillerStatusEffect.new("gelatinous_status", 1)
	var ctx : StatusEffectApplicationContext = StatusEffectApplicationContext.new(self, 
		effect, id)
	controller.apply_status(ctx)
	
func check_split():
	if get_health() <= get_max_health()/2:
		next_move = SplitActorPremove.new(2, self, split_enemy_resource)
		move_updated.emit(next_move)
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
