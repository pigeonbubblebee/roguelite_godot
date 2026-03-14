class_name ThornedArmorStatusEffect
extends FollowUpStatusEffect

func _init(id: String, owner: Actor, event_bus: BattleEventBus, event_hook_name: String, _stacks: int = 1):
	super._init(id, owner, event_bus, event_hook_name, _stacks)

func execute(dmg_context, context, controller):
	for actor in dmg_context.hit_actors:
		if actor == _owner:
			var fua = SupportFireFollowUp.new()
			fua.execute(dmg_context, context, controller)
			reduce_stacks()
