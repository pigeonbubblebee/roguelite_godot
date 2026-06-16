class_name BeserkersFuryCard
extends Card

var damage : int = 100

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	
	var player = context.get_player()
	
	var status_effects = player.get_status_manager().get_active_status()
	
	var additional_damage = 0
	
	for status in status_effects:
		if status.get_status_id() == "rage_status":
			additional_damage = status.get_stacks() * 10
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage + additional_damage)\
		.enqueue()
