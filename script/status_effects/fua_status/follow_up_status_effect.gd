class_name FollowUpStatusEffect
extends StatusEffect

func _init(id: String, owner: Actor, event_bus: BattleEventBus, event_hook_name: String, stacks: int = 1):
	super._init(id, owner, stacks)
	
	event_bus.connect(event_hook_name, Callable(self, "execute"))
	
# Each FuA must define its own execute & arg

func get_is_turn_based() -> bool:
	return false
