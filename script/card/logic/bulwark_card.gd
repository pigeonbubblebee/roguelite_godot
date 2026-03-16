class_name BulwarkCard
extends Card

var armor : int = 75

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)

	var action = BattleRuntimeHelper.generate_basic_defense_action(context)
	
	action.started.connect( func():
		var armor_context = ArmorGainContext.new(context.get_player(), armor, context.get_player())
		controller.apply_armor(armor_context)
	)
	controller.enqueue_action( action )

func on_discard(context: BattleContext, controller: BattleController):
	super.on_discard(context, controller)
	
	var fua = CardPlayFollowUp.new(play, self.id)
	
	fua.execute(context, controller)	

func get_buff_target_index(total_targets: int) -> Array[int]:
	return get_index_buff_single_target(total_targets)
