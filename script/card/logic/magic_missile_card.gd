class_name MagicMissileCard
extends Card

var damage : int = 45
var multistrike_amount : int = 3

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var selected_enemys = context.get_selected_enemies_aoe(preview)
	
	if preview:
		return EffectSequenceBuilder.new(context, controller)\
			.as_card(self)\
			.multi_damage(selected_enemys, damage, damage)
	
	var sequence = EffectSequenceBuilder.new(context, controller)\
		.as_card(self)
		
	for i in range(multistrike_amount):
		var target = selected_enemys.pick_random()
		sequence.damage(target, damage)
		
		if i < multistrike_amount - 1:
			sequence.delay()
			
	return sequence
		
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
