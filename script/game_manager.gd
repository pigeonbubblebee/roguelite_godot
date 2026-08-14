class_name GameManager
extends Node

##################
##### SCENES #####
##################

@export var battle_scene: PackedScene
@export var map_scene: PackedScene
@export var transition_scene: PackedScene
@export var treasure_scene: PackedScene

#######################
##### PLAYER DATA #####
#######################

@export var player_actor: ActorData

var player_data: PlayerData

signal player_data_updated(data: PlayerData)

###################
##### TESTING #####
###################

@export var test_encounter: EncounterData
@export var test_character: StartingCharacter
@export var test_floor: MapFloorData

#########################
##### CURRENT STATE #####
#########################

var _current_scene
var _current_battle_controller: BattleController
var _current_map_controller: MapController
var _current_floor_manager: FloorManager

func _ready() -> void:
	_current_floor_manager = FloorManager.new()
	_current_floor_manager.load_floor_data(test_floor)

	load_player_data()
	load_map()
	# load_battle(data)
	
###################
##### LOADING #####
###################

func load_battle(battle_data: BattleData) -> void:
	# Load battle scene (UI / interface)
	var battle_instance := battle_scene.instantiate() as BattleScene
	add_child(battle_instance)
	_current_scene = battle_instance

	# Create controller for battle logic
	var controller := BattleController.new()
	add_child(controller)
	_current_battle_controller = controller

	# GameManager <-> Controller
	_current_battle_controller.battle_finished.connect(on_battle_finished)
	_current_battle_controller.player_data_change_request.connect(
		apply_player_data_change
	)
	controller.bind_player_data(player_data)

	controller.load_battle(battle_data)
	battle_instance.bind_controller(controller)
	
	controller.battle_started.emit()


func load_map(create_new_map: bool = true) -> void:
	var map_instance := map_scene.instantiate() as MapScene
	add_child(map_instance)
	_current_scene = map_instance

	if create_new_map:
		var map_generator: MapGenerator = MapGenerator.new()
		map_generator.initialize()

		var controller := MapController.new()
		add_child(controller)
		_current_map_controller = controller

		_current_map_controller.player_moved.connect(process_room_enter)

		controller.load_map(map_generator.dungeon)

	map_instance.bind_controller(_current_map_controller)
	map_instance.bind_game_manager(self)

func load_treasure() -> void:
	var treasure_instance := treasure_scene.instantiate() as TreasureScene
	add_child(treasure_instance)
	_current_scene = treasure_instance

	var controller := TreasureController.new()

	controller.bind_player_data(player_data)
	treasure_instance.bind_controller(controller)

	treasure_instance.exit_requested.connect(on_treasure_exit)
	controller.player_data_change_request.connect(apply_player_data_change)

	treasure_instance.bind_game_manager(self)


######################
##### TRANSITION #####
######################

func transition(action: Callable) -> void:
	var transition := transition_scene.instantiate() as TransitionScene
	add_child(transition)

	await transition.covered

	action.call()

	transition.uncover()

	await transition.tree_exited

###########################
##### ROOM PROCESSING #####
###########################

func process_room_enter(room: MapNode) -> void:
	if room.type == MapNode.RoomType.TREASURE:
		_enter_treasure_room()
		return

	if _is_battle_room(room.type):
		_enter_battle_room(room)


func _is_battle_room(room_type: MapNode.RoomType) -> bool:
	return (
		room_type == MapNode.RoomType.COMBAT
		or room_type == MapNode.RoomType.KEY
		or room_type == MapNode.RoomType.ELITE
	)


func _enter_treasure_room() -> void:
	transition(func():
		_current_scene.queue_free()
		load_treasure()
	)

func _enter_battle_room(room: MapNode) -> void:
	_current_scene.movement_enabled = false

	transition(func():
		_current_scene.queue_free()

		var battle := _create_battle_for_room(room)
		load_battle(battle)
	)

func _create_battle_for_room(room: MapNode) -> BattleData:
	var battle := instantiate_test_battle_data()
	var encounter = _current_floor_manager.load_encounter()

	battle.room_type = room.type

	if room.type == MapNode.RoomType.ELITE:
		encounter = _current_floor_manager.load_encounter_elite()

	_add_encounter_actors_to_battle(battle, encounter)

	return battle

func _add_encounter_actors_to_battle(
	battle: BattleData,
	encounter
) -> void:
	for i in range(encounter.enemies.size()):
		var enemy = encounter.enemies[i]
		var premove_index := 0

		if encounter.premove_index.size() > 0:
			premove_index = encounter.premove_index[i]

		battle.actors.append({
			"data": enemy,
			"premove_index": premove_index
		})

###########################
##### NODE COMPLETION #####
###########################

func on_battle_finished() -> void:
	# TODO: Make a global function for processing node clears
	#       for all node types.
	transition(func():
		_current_scene.queue_free()
		_current_battle_controller.queue_free()

		_current_map_controller.finish_current_node()

		load_map(false)
	)


func on_treasure_exit(treasure_done) -> void:
	# TODO: Make a global function for processing node clears
	#       for all node types.
	transition(func():
		_current_scene.queue_free()

		if treasure_done:
			_current_map_controller.finish_current_node()

		load_map(false)
	)

###########################
##### DATA INSTANCING #####
###########################

func instantiate_test_battle_data() -> BattleData:
	var battle_data := BattleData.new()

	battle_data.actors.append({
		"data": player_actor,
		"premove_index": 0
	})

	battle_data.player_health = player_data.health

	for card in player_data.deck:
		battle_data.deck.append(card["CARD_ID"])
		
	for item in player_data.items:
		battle_data.items.append(item["ITEM_ID"])
		
	battle_data.weapon = player_data.weapon["ITEM_ID"]

	return battle_data

func load_player_data() -> void:
	player_data = PlayerData.new()

	player_data.health = player_actor.max_health
	player_data.max_health = player_actor.max_health
	player_data.gold = 100
	player_data.keys = 0

	for card in test_character.starting_deck:
		player_data.deck.append(
			CardDatabase.get_card(card.card_id)
	)
	
	for item in test_character.starting_items:
		player_data.items.append(
			ItemDatabase.get_item(item.item_id)
	)

	player_data.weapon = ItemDatabase.get_item("longsword_item")

func apply_player_data_change(effect) -> void:
	effect.apply(player_data)
	player_data_updated.emit(player_data)
