class_name SymphonyModifier
extends CardModifier

var damage_amp = 0.25

func on_card_played(card: Card, battle_context: BattleContext, controller: BattleController):
	if card == _owner:
		var effect = SymphonyStatusEffect.new("symphony_status", 
			stacks)
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
		EffectSequenceBuilder.new(battle_context, controller)\
			.as_modifier(self)\
			.use_action(custom_action)\
			.apply_status(battle_context.get_player(), effect)\
			.enqueue()
func get_name():
	return "Symphony"

func get_selection_prompt():
	return CardSelectionContext.SYMPHONY_PROMPT
