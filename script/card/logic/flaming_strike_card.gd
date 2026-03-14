class_name FlamingStrikeCard
extends Card

var damage : int = 60
var status_buildup : int = 4
var status_id : String = "burn_status"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	var hit_actors: Array[Actor] = [ selected_enemy ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
	damage_context.source_name = "flaming_strike_card"
	damage_context.add_tag(DamageContext.TAG_CARD)
	
	var effect = BurnStatusEffect.new(status_id, selected_enemy, status_buildup)
	
	var application_status = StatusEffectApplicationContext.new(selected_enemy, effect, context.get_player())
	controller.apply_status(application_status)
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(selected_enemy))
	controller.enqueue_action(action)
	
	controller.apply_damage(damage_context)
