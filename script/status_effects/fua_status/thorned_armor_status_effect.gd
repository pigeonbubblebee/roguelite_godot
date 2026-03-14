class_name ThornedArmorStatusEffect
extends FollowUpStatusEffect

func _init(id: String, owner: Actor, event_bus: BattleEventBus, event_hook_name: String, stacks: int = 1):
	super._init(id, owner, event_bus, event_hook_name, stacks)

func on_turn_start(actor: Actor, context: BattleContext, controller: BattleController):
	if not actor == _owner:
		return
	
	#print("turn start")	
	
	reduce_stacks()

func execute(dmg_context: DamageContext , context: BattleContext, controller: BattleController):
	for actor in dmg_context.hit_actors:
		if actor == _owner:
			if(dmg_context.armor_damage_dealt[_owner] > 0):
				var fua = ThornedArmorFollowUp.new()
				fua.execute(dmg_context, context, controller)
