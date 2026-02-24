extends Control

# Actor Icons For Action Bar
@export var actor_icon_scene: PackedScene
var actor_icons: Array[Control] = []
@export var _actor_icon_container_path: NodePath
@onready var actor_icon_container = get_node(_actor_icon_container_path)

func bind(manager: TurnManager):
	var turn_manager = manager
	# connect signal to update action bar
	turn_manager.connect("active_actors_updated", Callable(self, "update_ui"))
	update_ui(turn_manager.get_active_actors())  # initial load

func update_ui(active_actors: Array[Actor]):
	# Adds excess actors if new actor joins battle
	for i in range(active_actors.size()):
		if i >= actor_icons.size():
			var icon = actor_icon_scene.instantiate()
			actor_icon_container.add_child(icon)
			actor_icons.append(icon)
			
	# Remove excess actor icons		
	for i in range(actor_icons.size()):
		if i >= active_actors.size():
			var icon = actor_icons[i]
			actor_icons.erase(icon)
			icon.queue_free()

	# Updates all actors
	for i in range(active_actors.size()):
		var actor = active_actors[i]
		var icon = actor_icons[i]
		icon.update_actor(actor, i == 0)
