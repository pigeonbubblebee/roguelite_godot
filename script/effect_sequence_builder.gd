class_name EffectSequenceBuilder
extends RefCounted

var context: BattleContext
var controller: BattleController

var _card: Card = null
var _override_source: String = ""

var _tags: Array[String] = []

var _steps: Array = []

var _required_alive_targets: Array[Actor] = []

var _custom_action: BattleVisualAction = null

var _owner = null

func _init(_context: BattleContext, _controller: BattleController, card: Card = null):
	context = _context
	controller = _controller
	_card = card
	
func as_card(card: Card) -> EffectSequenceBuilder:
	_card = card
	add_tag(DamageContext.TAG_CARD)
	return self

func set_source(name: String) -> EffectSequenceBuilder:
	_override_source = name
	return self

func add_tag(tag: String) -> EffectSequenceBuilder:
	_tags.append(tag)
	return self
	
func set_owner(owner) -> EffectSequenceBuilder:
	_owner = owner
	return self
	
func step(visual: BattleVisualAction, logic: Callable) -> EffectSequenceBuilder:
	_steps.append({
		"visual": visual,
		"logic": logic
	})
	return self

func custom(visual: BattleVisualAction, logic: Callable) -> EffectSequenceBuilder:
	return step(visual, logic)

func use_action(action: BattleVisualAction) -> EffectSequenceBuilder:
	_custom_action = action
	return self

func _get_source_name() -> String:
	if _override_source != "":
		return _override_source
	
	if _card != null:
		return _card.id
	
	return ""

func _get_owner():
	if not _owner:
		return context.get_player()
	return _owner
	
# Effect Helpers
func damage(
	target: Actor,
	amount: int,
	damage_type : DamageType.Type
) -> EffectSequenceBuilder:
	if target == null:
		return self
	
	_required_alive_targets.append(target)
	
	var hit_actors : Array[Actor] = [target]
	
	var dmg = BattleRuntimeHelper.generate_damage_context(
		amount,
		hit_actors,
		_get_owner()
	)
	
	var source = _get_source_name()
	if source != "":
		dmg.source_name = source
	
	if damage_type != null:
		dmg.damage_type = damage_type
	
	for tag in _tags:
		dmg.add_tag(tag)
	
	return step(
		PlayParticleEffectAction.new(target),
		func(): controller.apply_damage(dmg)
	)

func multi_damage(
	targets: Array[Actor],
	main_damage: int,
	damage_type : DamageType.Type,
	blast_damage := 0,
) -> EffectSequenceBuilder:
	
	if targets.is_empty():
		return self
	
	_required_alive_targets.append_array(targets)
	
	var dmg = BattleRuntimeHelper.generate_damage_context(
		main_damage,
		targets,
		_get_owner(),
		blast_damage
	)
	
	var source = _get_source_name()
	if source != "":
		dmg.source_name = source
	
	if damage_type != null:
		dmg.damage_type = damage_type
	
	for tag in _tags:
		dmg.add_tag(tag)
	
	# visuals only for alive targets
	for t in targets:
		if not t._processing_death:
			step(PlayParticleEffectAction.new(t), (func(): pass))
	
	# apply once
	step(null, func(): controller.apply_damage(dmg))
	
	return self
	
func armor(target: Actor, amount: int) -> EffectSequenceBuilder:
	if target == null:
		return self
	
	var armor_ctx = ArmorGainContext.new(
		target,
		amount,
		_get_owner()
	)
	
	return step(
		PlayParticleEffectAction.new(target, "armor"),
		func(): controller.apply_armor(armor_ctx)
	)

func apply_status(target: Actor, effect: StatusEffect) -> EffectSequenceBuilder:
	if target == null:
		return self
	
	var status_ctx = StatusEffectApplicationContext.new(
		target,
		effect,
		_get_owner()
	)
	
	return step(
		null,
		func(): controller.apply_status(status_ctx)
	)
	
func apply_status_multi(targets: Array[Actor], effect_factory: Callable) -> EffectSequenceBuilder:
	for t in targets:
		if t._processing_death:
			continue
		var effect = effect_factory.call(t)
		apply_status(t, effect)
	return self
	
func draw_card(
	amount : int = 1
) -> EffectSequenceBuilder:
	return step(
		null,
		func(): controller.draw_card(amount)
	)
	
func discard_card(
	amount : int = 1
) -> EffectSequenceBuilder:
	var selection_context = BattleRuntimeHelper.generate_discard_card_selection_context(
		context, 
		controller, 
		amount)
	return step(
		CardSelectionAction.new(selection_context),  # visual
		func(): controller.start_card_selection(selection_context)
	)

func add_card_to_hand(
	id : String = "strike_card" # Change Default to smth else
)  -> EffectSequenceBuilder:
	return step(
		null,
		func(): controller.add_card_to_hand(id)
	)

func repeat(times: int, fn: Callable) -> EffectSequenceBuilder:
	for i in range(times):
		fn.call(self, i)
	return self
	
func enqueue() -> void:
	# Skip if ALL required targets are dead
	if not _required_alive_targets.is_empty():
		var any_alive := false
		for t in _required_alive_targets:
			if not t._processing_death:
				any_alive = true
				break
		
		if not any_alive:
			return
	
	var action: BattleVisualAction = _custom_action
	if action == null:
		action = BattleRuntimeHelper.generate_basic_attack_action(context)
	
	# Build visuals
	for s in _steps:
		if s.visual:
			if action is ParallelAction:
				action.append_action(s.visual)
			else:
				push_warning("Visual action for EffectBuilder not parallel action")
				controller.enqueue_action(s.visual)
	
	# Attach logic
	action.started.connect(func():
		for s in _steps:
			if s.logic:
				s.logic.call()
	)
	
	action.finished.connect(func():
		_steps.clear()
		_tags.clear()
	)
	
	controller.enqueue_action(action)
