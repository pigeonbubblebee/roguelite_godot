class_name StormStatusEffect
extends FollowUpStatusEffect

var event_hook_name : String = "damage_dealt"

func _init(id: String, event_bus: BattleEventBus, stacks: int = 1):
	super._init(id, event_bus, event_hook_name, stacks)

func execute(dmg_context, context, controller):
	if not dmg_context.damage_owner == _owner:
		return
		
	if dmg_context.source_name == StormFollowUp.DAMAGE_SOURCE_NAME:
		return
		
	var fua = StormFollowUp.new(_stacks)
	
	fua.execute(dmg_context, context, controller)
