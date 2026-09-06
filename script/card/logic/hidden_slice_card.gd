class_name HiddenSliceCard
extends Card

var damage : int = 30
var multistrike_amount : int = 2

var is_discarded = false

func build_sequence(context: BattleContext, controller: BattleController, preview: bool = false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)

	if is_discarded:
		target = context.get_actors_of_faction(Faction.Type.ENEMY).pick_random()
		is_discarded = false
	var sequence = EffectSequenceBuilder.new(context, controller)\
		.as_card(self)
		
	for i in range(multistrike_amount):
		sequence.damage(target, damage)

		if i < multistrike_amount - 1:
			sequence.delay()
			
	return sequence
	
func on_discard(context: BattleContext, controller: BattleController):
	super.on_discard(context, controller)
	
	is_discarded = true
	
	var fua = CardPlayFollowUp.new(play, self.id)
	
	fua.execute(context, controller)	
