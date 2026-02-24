class_name ActorUIManager
extends Control

@export var _enemy_ui_container_path: NodePath
@onready var enemy_ui_container = get_node(_enemy_ui_container_path)
@export var _ally_ui_container_path: NodePath
@onready var ally_ui_container = get_node(_ally_ui_container_path)
var enemy_ui_array : Array[EnemyActorUI] = []
var ally_ui_array : Array[ActorUI] = []

var current_card : Card = null
var hovered_enemy = null

@export var target_texture: Texture2D
@export var blast_target_texture: Texture2D
@export var buff_target_texture: Texture2D

signal hovered_enemy_change(hover)

func _ready() -> void:
	self.connect("hovered_enemy_change", Callable(self, "on_hovered_enemy_changed"))

func bind(controller: BattleController):
	var turn_manager = controller.get_turn_manager()
	turn_manager.active_actors_updated.connect(update_ui)
	update_ui(turn_manager.get_active_actors())
	
func update_ui(active_actors: Array[Actor]):
	var actor_ui_array = enemy_ui_array + ally_ui_array
	var ui_actors = []
	for ui in actor_ui_array:
		ui_actors.append(ui.actor)
	
	for i in active_actors.size():
		if not ui_actors.has(active_actors[i]):
			load_actor_ui(active_actors[i])
	for ui in actor_ui_array:
		if not active_actors.has(ui.actor):
			if ally_ui_array.has(ui):
				ally_ui_array.erase(ui)
			if enemy_ui_array.has(ui):
				enemy_ui_array.erase(ui)	
			actor_ui_array.erase(ui)
			ui.queue_free()
			
	for ui in actor_ui_array:
		_position_actor_ui(ui, ui.actor.get_team_position(), ui.actor.get_actor_faction())
	
func load_actor_ui(actor: Actor):
	var actor_ui = actor.actor_data.ui_scene.instantiate()
	actor_ui.actor = actor
	
	if actor.get_actor_faction() == Faction.Type.ENEMY:
		enemy_ui_array.append(actor_ui)
		enemy_ui_container.add_child(actor_ui)
		actor_ui.connect("hover_started", Callable(self, "start_hovered_enemy"))
		actor_ui.connect("hover_ended", Callable(self, "end_hovered_enemy"))
	elif actor.get_actor_faction() == Faction.Type.ALLY:
		ally_ui_array.append(actor_ui)
		ally_ui_container.add_child(actor_ui)
	
	actor_ui.update_health_bar()
	
	_position_actor_ui(actor_ui, actor.get_team_position(), actor.get_actor_faction())
	
func _position_actor_ui(actor_ui: ActorUI, team_position: int, faction: Faction.Type):
	var spacing: float = 64
	var x_pos: float = (team_position) * spacing
	var y_pos: float = 80 + (20 if team_position%2 == 0 else 0)
	
	actor_ui.position = Vector2(x_pos, y_pos)	

func start_hovered_enemy(enemy_actor: EnemyActorUI):
	hovered_enemy = enemy_actor

	hovered_enemy_change.emit(hovered_enemy)

func end_hovered_enemy(enemy_actor: EnemyActorUI):
	if hovered_enemy == enemy_actor:
		hovered_enemy = null
		
	hovered_enemy_change.emit(hovered_enemy)

func on_card_drag_started(card: Card):
	current_card = card
	
func on_card_entered_drop_zone(card: Card):
	update_ally_targets(current_card.get_buff_target_index(ally_ui_array.size()))
func on_card_exited_drop_zone(card: Card):
	clear_ally_targets()

func on_card_drag_ended(card: Card):
	current_card = null
	clear_enemy_targets()
	clear_ally_targets()

func on_hovered_enemy_changed(enemy):
	if not hovered_enemy or not current_card:
		clear_enemy_targets()
		return
		
	if not current_card.target_drag:
		return
	
	var hovered_enemy_index = 0
	hovered_enemy_index = hovered_enemy.actor.get_team_position()
	update_enemy_targets(current_card.get_target_index(enemy_ui_array.size(), hovered_enemy_index))
	
func update_enemy_targets(indicies: Array[int]):
	clear_enemy_targets()
	if current_card == null or hovered_enemy == null:
		return
	for i in range(indicies.size()):
		enemy_ui_array[indicies[i]].set_target_visibility(true, 
			target_texture if i == 0 else blast_target_texture)

func clear_enemy_targets():
	for i in range(enemy_ui_array.size()):
		enemy_ui_array[i].set_target_visibility(false)

func update_ally_targets(indicies: Array[int]):
	clear_ally_targets()
	if current_card == null:
		return
	for i in range(indicies.size()):
		ally_ui_array[indicies[i]].set_target_visibility(true, 
			buff_target_texture)
			
func clear_ally_targets():
	for i in range(ally_ui_array.size()):
		ally_ui_array[i].set_target_visibility(false)

func get_ui_for_actor(actor) -> ActorUI:
	var actor_ui_array = enemy_ui_array + ally_ui_array
	
	for actor_ui in actor_ui_array:
		if actor_ui.actor == actor:
			return actor_ui
	
	return null
