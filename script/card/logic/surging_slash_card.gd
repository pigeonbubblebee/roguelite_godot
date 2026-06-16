class_name SurgingSlashCard
extends Card

var damage : int = 100
var armor : int = 100

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	
	var player = context.get_player()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.armor(context.get_player(), armor)\
		.enqueue()
	
