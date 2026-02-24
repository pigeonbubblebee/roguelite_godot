class_name EnemyActor
extends Actor

var fixed_speed_temp = 66.6666667

func get_speed() -> float:
	return fixed_speed_temp

func take_action() -> void:
	print("Enemy Turn Taken")

func get_actor_faction() -> Faction.Type:
	return Faction.Type.ENEMY
	
func take_damage(damage: int, ctx: DamageContext) -> void:
	super.take_damage(damage, ctx)
	
	if(_health <= 0):
		request_death()

func get_actor_name() -> String:
	return "Enemy"
