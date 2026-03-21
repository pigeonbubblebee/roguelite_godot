class_name FlamingStrikeCard
extends Card

var damage : int = 40
var status_stacks : int = 4
var status_id : String = "burn_status"
var damage_type : DamageType.Type = DamageType.Type.FIRE

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	var effect = BurnStatusEffect.new(
		status_id, 
		context.get_player(), 
		status_stacks)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.apply_status(target, effect)\
		.enqueue()
	
	
