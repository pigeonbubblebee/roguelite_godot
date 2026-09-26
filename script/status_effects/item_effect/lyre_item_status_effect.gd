extends ItemStatusEffect

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if not context.source is StatusEffect:
		return
	if not context.source.get_status_id() == "symphony_status":
		return
	
	if context.damage_owner == _owner:
		var amt = 0
		var deck = controller.get_hand_manager().get_all_cards_in_play()
		
		for card in deck:
			if card.id == "mana_burn_card":
				amt += 1
				
		context.add_damage_percent(0.1 * amt)
