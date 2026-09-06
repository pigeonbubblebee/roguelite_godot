class_name QuickStrikeCard
extends Card

var damage : int = 30
var multistrike_amount : int = 3

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	var sequence = EffectSequenceBuilder.new(context, controller)\
		.as_card(self)
		
	for i in range(multistrike_amount):
		sequence.damage(target, damage)
		
		if i < multistrike_amount - 1:
			sequence.delay()
			
	return sequence
	
