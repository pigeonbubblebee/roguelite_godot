extends ItemStatusEffect

var damage_percent_bonus = 0.4

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		context.add_damage_percent(damage_percent_bonus)

func on_turn_start(actor: Actor, battle_context: BattleContext, controller: BattleController):
	if actor == _owner:
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_status(self)\
			.use_action(custom_action)\
			.shuffle_card_to_deck("mana_burn_card")\
			.enqueue()
