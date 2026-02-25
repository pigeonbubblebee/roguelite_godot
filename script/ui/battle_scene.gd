class_name BattleScene
extends Node2D

#########################################
##### ORCHESRATES BATTLE UI/VISUALS #####
#########################################

@export var _battle_hud_path: NodePath
@onready var battle_hud = get_node(_battle_hud_path)

@export var _actor_ui_path: NodePath
@onready var actor_ui = get_node(_actor_ui_path)

@export var _hand_ui_path: NodePath
@onready var hand_ui = get_node(_hand_ui_path)

@export var _end_turn_button_path: NodePath
@onready var end_turn_button = get_node(_end_turn_button_path)

@export var _scene_camera_path: NodePath
@onready var scene_camera = get_node(_scene_camera_path)

@export var _particle_effect_helper_path: NodePath
@onready var particle_effect_helper = get_node(_particle_effect_helper_path)

var _battle_action_manager: BattleActionManager

var _controller: BattleController

func bind_controller(controller: BattleController) -> void:
	_controller = controller
	
	# Init battle action visual manager
	
	_battle_action_manager = BattleActionManager.new()
	add_child(_battle_action_manager)
	
	_battle_action_manager.bind(self)
	controller.request_visual_action_enqueue.connect(_handle_visual_action_enqueue)
	
	# Bind UI components
	hand_ui.bind(controller)
	actor_ui.bind(controller)
	battle_hud.bind(controller)
	
	# UI to Controller
	end_turn_button.pressed.connect(controller.on_end_turn_pressed)
	actor_ui.hovered_enemy_change.connect(controller.on_hovered_enemy_change)
	hand_ui.card_ui_play_request.connect(controller.on_card_ui_play_request)
	
	# UI-only interactions
	_battle_action_manager.queue_started.connect(hand_ui.on_action_queue_started)
	_battle_action_manager.queue_finished.connect(hand_ui.on_action_queue_finished)
	
	actor_ui.hovered_enemy_change.connect(battle_hud.on_hovered_enemy_change)
	
	hand_ui.card_drag_started.connect(actor_ui.on_card_drag_started)
	hand_ui.card_drag_ended.connect(actor_ui.on_card_drag_ended)
	hand_ui.card_entered_drop_zone.connect(actor_ui.on_card_entered_drop_zone)
	hand_ui.card_exited_drop_zone.connect(actor_ui.on_card_exited_drop_zone)
	
	hand_ui.card_hover_started.connect(battle_hud.on_card_hover_started)
	hand_ui.card_hover_ended.connect(battle_hud.on_card_hover_ended)
	hand_ui.card_drag_ended.connect(battle_hud.on_card_drag_ended)

func _handle_visual_action_enqueue(action):
	_battle_action_manager.enqueue(action)

func request_ui_from_actor(actor: Actor) -> ActorUI:
	return actor_ui.get_ui_for_actor(actor)

func get_camera() -> BattleSceneCamera:
	return scene_camera
