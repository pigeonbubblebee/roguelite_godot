class_name EldritchBlastCard
extends Card

var damage : int = 90
var mana_crystal_card_id : String = "mana_crystal_card"
var damage_type : DamageType.Type = DamageType.Type.MAGIC

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.add_card_to_hand(mana_crystal_card_id)\
		.discard_card()\
		.enqueue()
