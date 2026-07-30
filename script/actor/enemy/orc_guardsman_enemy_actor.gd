class_name OrcGuardsmanEnemyActor
extends EnemyActor

var fixed_speed_temp = 99

var id : String = "orc_guardsman_enemy"

func _init(data):
	super._init(data)
	
	moveset.add_move(DefendActorPremove.new(90, self))
	moveset.add_move(DefendActorPremove.new(110, self))
	moveset.add_move(ArmorAttackActorPremove.new(60, id, self, 60))

func get_speed() -> float:
	return fixed_speed_temp

func get_actor_name() -> String:
	return "Orc Guardsman"
	
func on_battle_join(controller, context):
	var effect = ArmorShareStatusEffect.new("towering_shield_status", 1)
	var ctx : StatusEffectApplicationContext = StatusEffectApplicationContext.new(self, 
		effect, self)
	controller.apply_status(ctx)
	
func set_premove(index) -> void:
	moveset.current_index = index

func generate_next_move(context: BattleContext):
	next_move = moveset.get_next_move()
	move_updated.emit(next_move)
