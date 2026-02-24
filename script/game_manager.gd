extends Node

@export var battle_scene: PackedScene

var _current_scene
var _current_controller: BattleController
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
	battle_instance.add_child(controller)
	_current_controller = controller

	controller.load_battle(battle_data)
	battle_instance.bind_controller(controller)
	
func _ready() -> void:
	var data = BattleData.new()
	
	data.actors.append(player_actor)
	
	for enemy in test_encounter.enemies:
		data.actors.append(enemy)
	
	for card in test_character.starting_deck:
		data.deck.append(card)
	
	load_battle(data)
