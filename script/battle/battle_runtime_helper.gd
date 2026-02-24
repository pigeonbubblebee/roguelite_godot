class_name BattleRuntimeHelper

static func generate_basic_attack_action(context: BattleContext, actor: Actor = context.get_player()) -> BattleVisualAction:
	var parallel = ParallelAction.new([
		MoveForwardAction.new(actor, 20, 0.12),
		ShakeCameraAction.new(0.65)
	])
	
	return parallel

static func generate_heavy_attack_action(context: BattleContext) -> BattleVisualAction:
	var parallel = ParallelAction.new([
		MoveForwardAction.new(context.get_player(), 20, 0.12),
		# SlashEffectAction.new(context.selected_enemy),
		ShakeCameraAction.new(2, 0.12)
	])
	
	return parallel

static func generate_damage_context(damage, hit_actors, blast_damage = 0, type = DamageType.Type.PHYSICAL) -> DamageContext:
	var damage_context = DamageContext.new()
	
	damage_context.damage = damage
	damage_context.blast_damage = blast_damage
	damage_context.hit_actors = hit_actors
	damage_context.source_faction = Faction.Type.ALLY
	damage_context.damage_type = type
	
	return damage_context
