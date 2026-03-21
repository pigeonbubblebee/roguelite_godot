class_name ScorchCard
extends Card

var damage : int = 50
var status_buildup : int = 2
var status_id : String = "burn_status"
var damage_type : DamageType.Type = DamageType.Type.FIRE

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var hit_actors = context.get_selected_enemies_aoe()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.multi_damage(hit_actors, damage, 
			damage_type, damage)\
		.apply_status_multi(hit_actors, func(t): 
				return BurnStatusEffect.new(status_id, 
				context.get_player(), status_buildup))\
		.enqueue()
		
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
