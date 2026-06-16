class_name ThrustCard
extends Card

var damage : int = 60
var status_turns = 2
var status_id = "vulnerable_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	var effect = DamageTakenAmplificationStatusEffect.new(status_id, 
		status_turns)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.apply_status(target, effect)\
		.enqueue()
