class_name InvigorationStatusEffect
extends StatusEffect

var status_id = "empowered_status"

func get_is_turn_based() -> bool:
	return false

func on_card_played(card: Card, context: BattleContext, controller: BattleController):
	if not card.get_base_cost() >= 2:
		return
		
	var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)
	var effect = DamageAmplificationStatusEffect.new(status_id, 
		_stacks*InvigorationCard.EMPOWERED_AMOUNT)
		
	EffectSequenceBuilder.new(context, controller)\
		.as_status(self)\
		.use_action(custom_action)\
		.armor(context.get_player(), _stacks*InvigorationCard.ARMOR_AMOUNT)\
		.apply_status(context.get_player(), effect)\
		.enqueue()
