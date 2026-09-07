class_name EldritchBlastCard
extends Card

var damage : int = 90
var mana_crystal_card_id : String = "mana_crystal_card"
var mana_burn_card_id : String = "mana_burn_card"

func build_sequence(context: BattleContext, controller: BattleController, preview:= false) -> EffectSequenceBuilder:
	var target = context.get_selected_enemy(preview)
	
	return EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage)\
		.add_card_to_hand(mana_crystal_card_id)\
		.shuffle_card_to_deck(mana_burn_card_id)
