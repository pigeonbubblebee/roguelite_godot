class_name SupportFireStatusEffect
extends FollowUpStatusEffect

func _init(id: String, owner: Actor, event_bus: BattleEventBus, event_hook_name: String, stacks: int = 1):
	super._init(id, owner, event_bus, event_hook_name, stacks)

func execute(dmg_context, context, controller):
	if not dmg_context.damage_owner == _owner:
		return
		
	if not dmg_context.has_tag(DamageContext.TAG_CARD):
		return
		
	var fua = SupportFireFollowUp.new()
	
	fua.execute(dmg_context, context, controller)

	reduce_stacks()
