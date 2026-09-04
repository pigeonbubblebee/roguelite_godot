class_name WildBarrageCard
extends Card

var damage : int = 20
var multistrike_amount : int = 2

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var hit_actors = context.get_selected_enemies_aoe()
	
	var sequence = EffectSequenceBuilder.new(context, controller)\
		.as_card(self)
		
	for i in range(multistrike_amount):
		sequence.multi_damage(hit_actors, damage, damage)
		
		if i < multistrike_amount - 1:
			sequence.delay()
			
	return sequence
	
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
