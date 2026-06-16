class_name SweepingWaveCard
extends Card

var status_stacks : int = 5
var status_id : String = "rage_status"
var damage : int = 60

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var hit_actors = context.get_selected_enemies_aoe()
	var player = context.get_player()
	var effect = RageStatusEffect.new(status_id, 
		status_stacks)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.multi_damage(hit_actors, damage, 
			damage)\
		.apply_status(player, effect)\
		.enqueue()
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
