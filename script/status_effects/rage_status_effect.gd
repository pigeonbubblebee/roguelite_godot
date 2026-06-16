class_name RageStatusEffect
extends StatusEffect

var rage_card_id = "beserkers_fury_card"

func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)

func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	add_rage(_context, _controller)

func stacks_updated(_context: BattleContext, _controller: BattleController):
	super.stacks_updated(_context, _controller)
	add_rage(_context, _controller)
	
func add_rage(_context: BattleContext, _controller: BattleController):
	var hand_manager = _controller.get_hand_manager()
	
	if ((not hand_manager.card_in_hand(rage_card_id)) and
		(not hand_manager.card_in_deck(rage_card_id)) and
		(not hand_manager.card_in_discard_pile(rage_card_id))):
		
		var custom_action = BattleRuntimeHelper.generate_light_camera_shake_action()

		EffectSequenceBuilder.new(_context, _controller)\
			.use_action(custom_action)\
			.add_card_to_hand(rage_card_id)\
			.enqueue()
			
func get_is_turn_based() -> bool:
	return false
