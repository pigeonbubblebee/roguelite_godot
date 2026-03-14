class_name SupportFireStatusEffect
extends FollowUpStatusEffect

func _init(id: String, owner: Actor, event_bus: BattleEventBus, event_hook_name: String, _stacks: int = 1):
	super._init(id, owner, event_bus, event_hook_name, _stacks)

func execute(dmg_context, context, controller):
	if not dmg_context.damage_owner == _owner:
		return
		
	if dmg_context.source_name == SupportFireCard.SUPPORT_FIRE_DAMAGE_SOURCE_NAME:
		return
		
	var fua = SupportFireFollowUp.new()
	
	fua.execute(dmg_context, context, controller)

	reduce_stacks()
