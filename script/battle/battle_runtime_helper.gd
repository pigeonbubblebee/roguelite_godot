class_name BattleRuntimeHelper

static func generate_basic_attack_action(context: BattleContext, actor: Actor = context.get_player()) -> BattleVisualAction:
	var parallel = ParallelAction.new([
		MoveForwardAction.new(actor, 20, 0.12),
		ShakeCameraAction.new(0.65),
		DelayAction.new()
	])
	
	return parallel
	
static func generate_basic_defense_action(context: BattleContext, actor: Actor = context.get_player()) -> BattleVisualAction:
	var parallel = ParallelAction.new([
		ShakeCameraAction.new(0.65),
		#PlayParticleEffectAction.new(actor, "armor"),
		DelayAction.new()
	])
	
	return parallel

static func generate_heavy_attack_action(context: BattleContext) -> BattleVisualAction:
	var parallel = ParallelAction.new([
		MoveForwardAction.new(context.get_player(), 20, 0.12),
		# SlashEffectAction.new(context.selected_enemy),
		ShakeCameraAction.new(2, 0.12),
		DelayAction.new()
	])
	
	return parallel

static func generate_light_camera_shake_action() -> BattleVisualAction:
	var parallel = ParallelAction.new([
		ShakeCameraAction.new(0.65)
	])
	
	return parallel

static func generate_damage_context(damage, hit_actors, damage_owner, blast_damage : int = 0, 
	type : DamageType.Type = DamageType.Type.PHYSICAL) -> DamageContext:
		
	var damage_context = DamageContext.new()
	
	damage_context.damage = damage
	damage_context.blast_damage = blast_damage
	damage_context.hit_actors = hit_actors
	damage_context.source_faction = Faction.Type.ALLY
	damage_context.damage_type = type
	damage_context.damage_owner = damage_owner
	
	return damage_context
	
static func generate_discard_card_selection_context(context: BattleContext, controller: BattleController, 
	amount : int = 1) -> CardSelectionContext:
	
	var result = generate_card_selection_context(context, controller, 
		CardSelectionContext.DISCARD_PROMPT, amount)
		
	result.finished.connect(func(selected_cards):
		if selected_cards:
			_handle_discard_sequence(selected_cards, context, controller)
	)
	
	return result
	
static func _handle_discard_sequence(selected_cards, context, controller):
	for selected_card in selected_cards:
		controller.discard_card(selected_card)
		await context.await_battle_actions()

static func generate_card_selection_context(context: BattleContext, controller: BattleController, 
	prompt : String, amount : int = 1) -> CardSelectionContext:
	
	var hand = controller.get_hand_manager().get_hand()	
	var card_selection_context = CardSelectionContext.new(hand, CardSelectionContext.DISCARD_PROMPT, amount)
	return card_selection_context
