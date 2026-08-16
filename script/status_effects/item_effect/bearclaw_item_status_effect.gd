extends ItemStatusEffect

var damage_percent_bonus = 0.3

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		context.add_damage_percent(damage_percent_bonus)

func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	if card.type == Card.CardType.ATTACK:
		return
		
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(BattleRuntimeHelper.generate_light_camera_shake_action())\
		.discard_card()\
		.enqueue()
