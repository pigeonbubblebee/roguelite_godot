class_name EnemyActor
extends Actor

signal move_updated(move: ActorPremove)
signal turn_finished(actor: Actor)

var next_move : ActorPremove

func get_next_move():
	return next_move

func take_action(context: BattleContext, controller: BattleController) -> void:
	reset_armor()
	if next_move:
		next_move.finished.connect(_on_move_finish, CONNECT_ONE_SHOT)
		move_updated.emit(null)
		
		next_move.execute(context, controller)

func get_remaining_av() -> float:
	return _remaining_av

func get_actor_faction() -> Faction.Type:
	return Faction.Type.ENEMY
	
func take_damage(damage: int, ctx: DamageContext) -> void:
	super.take_damage(damage, ctx)
	
	if(_health <= 0):
		request_death()

func get_actor_name() -> String:
	return "Enemy"
	
func _on_move_finish():
	turn_finished.emit(self)

func generate_next_move(context: BattleContext):
	push_error("get_enemy_next_move() must be implemented by subclasses")
