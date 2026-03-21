class_name FrozenStrikeCard
extends Card

var damage : int = 50
var armor : int = 40
var status_id : String = "fortitude_status"
var status_stacks : int = 2
var damage_type : DamageType.Type = DamageType.Type.COLD

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	
	var player = context.get_player()
	var effect = FortitudeStatusEffect.new(status_id, 
		status_stacks)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.armor(context.get_player(), armor)\
		.apply_status(player, effect)\
		.enqueue()
	
