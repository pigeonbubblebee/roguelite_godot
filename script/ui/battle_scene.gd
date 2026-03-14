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

@export var _confirm_selection_button_path: NodePath
@onready var confirm_selection_button = get_node(_confirm_selection_button_path)

@export var _card_selection_ui_path: NodePath
@onready var card_selection_ui = get_node(_card_selection_ui_path)
@export var _card_selection_prompt_path: NodePath
@onready var card_selection_prompt = get_node(_card_selection_prompt_path)

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
	
	controller.request_card_selection.connect(_on_request_card_selection)
	controller.card_selection_finished.connect(_on_card_selection_finished)
	
	# UI to Controller
	end_turn_button.pressed.connect(controller.on_end_turn_pressed)
	confirm_selection_button.pressed.connect(controller.on_confirm_selection_pressed)
	
	actor_ui.hovered_enemy_change.connect(controller.on_hovered_enemy_change)
	
	hand_ui.card_ui_play_request.connect(controller.on_card_ui_play_request)
	hand_ui.card_selection_started.connect(controller.on_card_selection_started)
	hand_ui.card_selection_ended.connect(controller.on_card_selection_ended)
	
	_battle_action_manager.queue_started.connect(controller.on_action_queue_started)
	_battle_action_manager.queue_finished.connect(controller.on_action_queue_finished)
	
	# UI-only interactions
	_battle_action_manager.queue_started.connect(hand_ui.on_action_queue_started)
	_battle_action_manager.queue_finished.connect(hand_ui.on_action_queue_finished)
	
	actor_ui.hovered_actor_change.connect(battle_hud.on_hovered_actor_change)
	actor_ui.hovered_status_icon_change.connect(battle_hud.on_hovered_status_icon_change)
	
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
	
func _on_request_card_selection(ctx):
	card_selection_ui.mouse_filter = card_selection_ui.MOUSE_FILTER_STOP
	confirm_selection_button.mouse_filter = card_selection_ui.MOUSE_FILTER_STOP
	
	card_selection_ui.visible = true
	
	card_selection_prompt.text = ctx.get_prompt()

	hand_ui.change_input_type(hand_ui.InputType.SELECTION)
	
func _on_card_selection_finished(ctx):
	card_selection_ui.mouse_filter = card_selection_ui.MOUSE_FILTER_IGNORE
	confirm_selection_button.mouse_filter = card_selection_ui.MOUSE_FILTER_IGNORE
	
	card_selection_ui.visible = false

	hand_ui.change_input_type(hand_ui.InputType.BATTLE)
