class_name SunderingStrikeCard
extends Card

var damage : int = 70
var status_buildup : int = 4
var status_id : String = "daze_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	if selected_enemy._processing_death:
		return
	
	var hit_actors: Array[Actor] = [ selected_enemy ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
	damage_context.source_name = "sundering_strike_card"
	damage_context.add_tag(DamageContext.TAG_CARD)
	
	var effect = DazeStatusEffect.new(status_id, context.get_player(), status_buildup)
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(selected_enemy))
	controller.enqueue_action(action)
	
	var application_status = StatusEffectApplicationContext.new(selected_enemy, effect, context.get_player())
	controller.apply_status(application_status)
	
	controller.apply_damage(damage_context)
