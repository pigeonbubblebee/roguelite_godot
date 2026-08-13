extends ItemStatusEffect

var status_id := "rage_status"
var rage_card_id = "beserkers_fury_card"

# empowered by default
func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)

func status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	if ctx.actor == _owner:
		if not ctx.status.get_status_id() == status_id:
			return
		if not ctx.is_preview:
			var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()
			EffectSequenceBuilder.new(context, controller)\
				.as_status(self)\
				.use_action(custom_action)\
				.modify_cards([controller.get_hand_manager().get_card_in_play(rage_card_id)], func(t): 
					return SharpnessModifier.new("sharpness_modifier"))\
				.enqueue()
