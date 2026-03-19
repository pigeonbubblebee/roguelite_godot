class_name FrostBarrierCard
extends Card

var armor : int = 140
var status_id : String = "fortitude_status"
var stacks : int = 4

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var action = BattleRuntimeHelper.generate_basic_defense_action(context)
	
	var armor_context = ArmorGainContext.new(context.get_player(), armor, context.get_player())
	
	var effect = FortitudeStatusEffect.new(status_id, 
		stacks)
	var application_status = StatusEffectApplicationContext.new(context.get_player(), effect, context.get_player())
	
	action.started.connect(func():
		controller.apply_armor(armor_context)
		
		controller.apply_status(application_status)
	)
	
	controller.enqueue_action( action )
	
func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
