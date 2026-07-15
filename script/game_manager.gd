extends Node

@export var battle_scene: PackedScene
@export var map_scene : PackedScene
@export var transition_scene : PackedScene

var _current_scene
var _current_battle_controller: BattleController
var _current_map_controller : MapController
var _current_turn_manager
var _current_hand_manager
var _current_battle_context

@export var player_actor: ActorData

@export var test_encounter: EncounterData
@export var test_character: StartingCharacter

# battle_data: BattleData
func load_battle(battle_data: BattleData) -> void:
	# Load Battle Scene (UI, Interface)
	var battle_instance := battle_scene.instantiate() as BattleScene
	add_child(battle_instance)
	_current_scene = battle_instance
	# Controller for logic
	var controller = BattleController.new()
	add_child(controller)
	_current_battle_controller = controller
	
	_current_battle_controller.battle_finished.connect(on_battle_finished)

	controller.load_battle(battle_data)
	battle_instance.bind_controller(controller)
	
func load_map(create_new_map : bool = true) -> void:
	var map_instance := map_scene.instantiate() as MapScene
	add_child(map_instance)
	_current_scene = map_instance
	
	if create_new_map:
		var map_generator : MapGenerator = MapGenerator.new()
		map_generator.initialize()
		
		var controller = MapController.new()
		add_child(controller)
		_current_map_controller = controller
		
		_current_map_controller.player_moved.connect(process_room_enter)
	
		controller.load_map(map_generator.dungeon)
		
	map_instance.bind_controller(_current_map_controller)
	
func _ready() -> void:
	load_map()
	#load_battle(data)
	
func transition(action: Callable) -> void:
	var transition := transition_scene.instantiate() as TransitionScene
	add_child(transition)
	
	print("straRTED")
	
	await transition.covered
	
	print("covered")

	action.call()
	
	transition.uncover()
	await transition.tree_exited
	
func process_room_enter(room : MapNode) -> void:
	if (room.type == MapNode.RoomType.COMBAT 
		or room.type == MapNode.RoomType.KEY 
		or room.type == MapNode.RoomType.ELITE):
			
		transition(func():
			_current_scene.queue_free()

			var battle := instantiate_test_battle_data()
			load_battle(battle)
		)

func on_battle_finished(): #TBD make a global func for processing node clears for all node types
	transition(func():
		_current_scene.queue_free()
		_current_map_controller.finish_current_node()

		load_map(false)
	)

func instantiate_test_battle_data() -> BattleData:
	var data = BattleData.new()
	
	data.actors.append(player_actor)
	
	for enemy in test_encounter.enemies:
		data.actors.append(enemy)
	
	for card in test_character.starting_deck:
		data.deck.append(card.card_id)
		
	return data
