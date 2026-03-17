class_name BattleController
extends Node

var _turn_manager: TurnManager
var _hand_manager: HandManager
var _battle_context: BattleContext
var _battle_data: BattleData
var _energy_manager: EnergyManager

var _is_first_turn = true

# Signals
signal battle_started
signal turn_started(actor: Actor)

signal card_drawn(card: Card)
signal card_played(card: Card)

signal energy_changed(new_energy: int)

signal request_visual_action_enqueue(action: BattleVisualAction)

signal request_card_selection(ctx : CardSelectionContext)
signal card_selection_finished(ctx : CardSelectionContext)

@export var log_card_play := false

func _input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_K:
		print("Debug: Killing Enemy!")
		if(_battle_context.get_hovered_enemy()):
			free_actor(_battle_context.get_hovered_enemy())

########################
##### LOADS BATTLE #####
########################

func load_battle(battle_data: BattleData):
	_battle_data = battle_data
	
	_create_managers()
	_create_context()
	_create_actors(battle_data.actors)
	_initialize_deck(battle_data.deck)
	_setup_connections()
	_start_battle()
	
####################
##### MANAGERS #####
####################

func _create_managers():
	_turn_manager = TurnManager.new()
	add_child(_turn_manager)
	_hand_manager = HandManager.new()
	add_child(_hand_manager)
	_energy_manager = EnergyManager.new()
	add_child(_energy_manager)
	
###################
##### CONTEXT #####
###################

func _create_context():
	_battle_context = BattleContext.new(_turn_manager, self)
	
#######################
##### ACTOR LOGIC #####
#######################

func _create_actors(actors: Array[ActorData]):
	for actor in actors:
		var actor_instance = actor.actor_script.new(actor)
		var faction = actor_instance.get_actor_faction()
			
		actor_instance.set_team_position(_get_next_team_position_for_faction(faction))
		_turn_manager.add_actor(actor_instance, _battle_context)
		
		actor_instance.died.connect(on_actor_death)
		actor_instance.armor_reset_request.connect(on_armor_reset_request)
		
		actor_instance.reset_health()
		
		if faction == Faction.Type.ENEMY:
			actor_instance.turn_finished.connect(_on_enemy_turn_finish)
		
func _get_next_team_position_for_faction(faction: Faction.Type) -> int:
	var max_pos := -1 # -1 for 0 indexing, bc returns max_pos+1
	
	for actor in _turn_manager.get_active_actors():
		if actor.get_actor_faction() == faction:
			max_pos = max(max_pos, actor.get_team_position())
	
	return max_pos + 1
	
######################
##### CARD LOGIC #####
######################

func _initialize_deck(deck: Array[String]):
	for entry in deck:
		_hand_manager.add_to_deck(entry)
	_hand_manager.shuffle_deck()
	
###################
##### SIGNALS #####
###################
		
func _setup_connections():
	_turn_manager.turn_started.connect(_on_turn_started)
	_turn_manager.turn_ready.connect(_on_turn_ready)
	_turn_manager.turn_ended.connect(_on_turn_ended)
	
	_hand_manager.card_drawn.connect(_on_card_drawn)
	_hand_manager.card_discarded.connect(_on_card_discarded)
	# _hand_manager.card_played.connect(_on_card_played)
	
	_energy_manager.energy_change.connect(_on_energy_change)
	_energy_manager.energy_change.connect(_battle_context.on_energy_change)
	
	_battle_context.setup_event_bus()
	
############################
##### STARTER FUNCTION #####
############################

## CALLED WHEN EVERYTHING IS LOADED IN

func _start_battle():
	_energy_manager.reset_energy()
	_turn_manager.progress_turn_order()
	battle_started.emit()
	for actor in _battle_context.get_actors_of_faction(Faction.Type.ENEMY):
		actor.generate_next_move(_battle_context)
	
############################
##### SIGNAL REACTIONS #####
############################

func _on_turn_ready(actor: Actor):
	load_next_actor_turn()

func _on_turn_started(actor: Actor):
	if actor.get_actor_faction() == Faction.Type.ALLY:
		_energy_manager.reset_energy()
		_hand_manager.draw_to_max()
	
	_battle_context.event_bus.turn_started.emit(actor, _battle_context, self)
	
	await _battle_context.await_battle_actions()

	if actor._processing_death:
		_turn_manager.finish_turn()
		return

	actor.take_action(_battle_context, self)	
	
	turn_started.emit(actor)
	
func _on_enemy_turn_finish(actor: Actor):
	await _battle_context.await_battle_actions()
	
	_turn_manager.finish_turn()
	actor.generate_next_move(_battle_context)
	
func _on_card_drawn(card: Card):
	card_drawn.emit(card)
	
func _on_card_discarded(card: Card):
	_battle_context.event_bus.on_card_discarded.emit(card, _battle_context, self)

func _on_card_played(card: Card):
	request_play_card(card)
	
func _on_energy_change(current: int):
	energy_changed.emit(current)

func _on_turn_ended(actor: Actor):
	_battle_context.event_bus.turn_ended.emit(actor, _battle_context, self)	
		
func on_actor_death(actor: Actor):
	free_actor(actor)
	
func on_armor_reset_request(context: ArmorResetContext):
	_battle_context.event_bus.on_armor_reset_request.emit(context, _battle_context, self)

## UI CONNECTIONS
	
func on_end_turn_pressed():
	if(_turn_manager._current_actor.get_actor_name() == "Player" and not _turn_manager.processing_turn_change):
		_turn_manager.finish_turn()
		
func on_confirm_selection_pressed():
	if _hand_manager.is_ready_to_end_selection():
		card_selection_finished.emit(_hand_manager.current_card_selection_context)
		_hand_manager.current_card_selection_context.finish()
		
		_hand_manager.current_card_selection_context = null
	
func on_hovered_enemy_change(actorUI: EnemyActorUI):
	if(not actorUI):
		_battle_context.clear_hovered_actor()
		return
	_battle_context.set_hovered_actor(actorUI.actor)
	
func on_card_ui_play_request(card_ui: CardGUI, card_logic: Card):
	if log_card_play:
		print("BattleController: UI REQUESTING TO PLAY CARD: " + card_logic.title)
	
	var hovered_enemy = _battle_context.get_hovered_enemy()
	
	if card_logic.target_drag: ## TARGET DRAG TO ENEMY CARDS
		if hovered_enemy:
			_battle_context.set_selected_actor(hovered_enemy)
			try_play_card_ui(card_ui, card_logic)
		else:
			card_ui.return_to_hand()
			return
	else:  ## DRAG & DROP CARDS
		var dist = card_ui.global_position.distance_to(card_ui.drag_original_position)

		if card_ui.is_in_drop_zone:
			try_play_card_ui(card_ui, card_logic)
		else:
			card_ui.return_to_hand()
			return

func try_play_card_ui(card_ui: CardGUI, card_logic: Card):
	if not request_play_card(card_logic):
		card_ui.return_to_hand()
		return
		
func on_card_selection_started(card: Card):
	_hand_manager.select_card(card)
	
func on_card_selection_ended(card: Card):
	_hand_manager.deselect_card(card)
		
func on_action_queue_started():
	get_context().action_started = true
func on_action_queue_finished():
	get_context().on_action_queue_clear()
	
##################################
##### RUNTIME LOGIC REQUESTS #####
##################################
	
func request_play_card(card: Card) -> bool:	
	if not card.can_play(_battle_context):
		if log_card_play:
			print("BattleController: CANNOT PLAY REQUESTED CARD: " + card.title)
		return false
	
	resolve_card(card)
	
	if log_card_play:
		print("BattleController: CAN PLAY REQUESTED CARD: " + card.title + ", CARD RESOLVED")
	
	return true
	
func resolve_card(card: Card):
	card.play(_battle_context, self)
	
	match card.effect_on_resolve(_battle_context, self):
		Card.ResolveEffect.DISCARD:
			_hand_manager.discard_card_from_play(card)
		Card.ResolveEffect.REMOVE:
			_hand_manager.remove_card_from_play(card)
		
	_energy_manager.use_energy(card.get_cost())
	card_played.emit(card)
	_battle_context.event_bus.on_card_played.emit(card, _battle_context, self)

func apply_damage(ctx: DamageContext):
	_battle_context.event_bus.before_damage_dealt.emit(ctx, _battle_context, self)
	
	var damage_dictionary = ctx.calculate_damage()
	for actor in damage_dictionary.keys():
		var damage_value = damage_dictionary[actor]
		
		var lost_values = actor.take_damage(damage_value, ctx)
		
		ctx.damage_dealt[actor] = lost_values[0]
		ctx.armor_damage_dealt[actor] = lost_values[1]
		
	_battle_context.event_bus.damage_dealt.emit(ctx, _battle_context, self)
	
func apply_armor(ctx: ArmorGainContext):
	_battle_context.event_bus.before_armor_applied.emit(ctx, _battle_context, self)
	
	var amount = ctx.calculate_armor()
	
	ctx.actor.add_armor(amount)
	ctx.armor_gained = amount
	
	_battle_context.event_bus.armor_applied.emit(ctx, _battle_context, self)
	
func apply_status(context: StatusEffectApplicationContext):
	context.status.set_owner(context.actor)
	context.actor.apply_status(context.status, _battle_context, self)
	
func draw_card(amt: int = 1):
	for i in range(amt):
		_hand_manager.draw_from_top()
		
func add_card_to_hand(card_id : String, amt : int = 1):
	for i in range(amt):
		var card = _hand_manager.init_card_script_from_id(card_id)
		_hand_manager.draw_card(card)
		
func discard_card(card: Card):
	_hand_manager.discard_card(card)
	card.on_discard(_battle_context, self)
		
func free_actor(actor: Actor):
	print(actor.actor_data.name + " DIED! PROCESSING REMOVAL")
	
	# Process dying animation
	var death_animation_action = PlayDeathAnimationAction.new(actor)
	enqueue_action(death_animation_action)
	await death_animation_action.finished
	
	## Update team positions
	var team_position = actor.get_team_position()
	var active_actors = _battle_context.get_actors_of_faction(actor.get_actor_faction())
	for i in range(active_actors.size()):
		var current_actor = active_actors[i]
		var current_position = current_actor.get_team_position()
		if current_position > team_position:
			current_actor.set_team_position(current_position - 1)
			
	## Remove from turn order
	_turn_manager.remove_actor(actor)
	
	## UI should then react
	## Turn Order UI, Actor Sprite UI
	
func load_next_actor_turn():
	if not _is_first_turn:
		var process_turn_pass_action = ProcessPassTurnAction.new()
		enqueue_action(process_turn_pass_action)
		
		await process_turn_pass_action.finished
	else:
		_is_first_turn = false
	
	_turn_manager.start_turn()

func start_card_selection(context: CardSelectionContext):
	_hand_manager.current_card_selection_context = context
	request_card_selection.emit(context)

func enqueue_action(action: BattleVisualAction):
	request_visual_action_enqueue.emit(action)
	
func gain_energy(amt: int = 1):
	_energy_manager.gain_energy(amt)
	
###################
##### GETTERS #####
###################

func get_turn_manager() -> TurnManager:
	return _turn_manager

func get_hand_manager() -> HandManager:
	return _hand_manager

func get_context() -> BattleContext:
	return _battle_context

func get_energy_manager() -> EnergyManager:
	return _energy_manager
