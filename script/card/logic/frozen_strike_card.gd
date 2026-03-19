class_name FrozenStrikeCard
extends Card

var damage : int = 50
var armor : int = 40
var status_id : String = "fortitude_status"
var stacks : int = 2

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemy = context.get_selected_enemy()
	
	if selected_enemy._processing_death:
		return
	
	var hit_actors: Array[Actor] = [ selected_enemy ]
	var damage_context = BattleRuntimeHelper.generate_damage_context(damage, hit_actors, context.get_player())	
	damage_context.source_name = "frozen_strike_card"
	damage_context.damage_type = DamageType.Type.COLD
	damage_context.add_tag(DamageContext.TAG_CARD)
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(PlayParticleEffectAction.new(selected_enemy))
	
	action.append_action(PlayParticleEffectAction.new(context.get_player(), "armor"))
	
	var armor_context = ArmorGainContext.new(context.get_player(), armor, context.get_player())
	
	var effect = FortitudeStatusEffect.new(status_id, 
		stacks)
	var application_status = StatusEffectApplicationContext.new(context.get_player(), effect, context.get_player())
	
	action.started.connect(func():
		controller.apply_status(application_status)
	
		controller.apply_armor(armor_context)
		
		controller.apply_damage(damage_context)
	)
	controller.enqueue_action(action)
	
