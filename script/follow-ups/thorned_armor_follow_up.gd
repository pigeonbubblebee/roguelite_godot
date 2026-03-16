class_name ThornedArmorFollowUp
extends FollowUp

var damage : int = 30
var card_id : String = "thorned_armor_card"

func execute(dmg_context: DamageContext, context: BattleContext, controller: BattleController):
	var target : Actor
	
	if dmg_context.damage_owner is Actor:
		target = dmg_context.damage_owner
	else:
		# implement getting a random actor from the faction
		push_error("Thorned Armor cannot find target!")
		return
	
	var action = BattleRuntimeHelper.generate_basic_attack_action(context)
	action.append_action(CardArtAction.new(context.get_player(), card_id))
	
	action.started.connect(func():
		var hit_actors: Array[Actor] = [ target ]
		var damage_context = BattleRuntimeHelper.generate_damage_context(damage, 
			hit_actors, context.get_player())	
		damage_context.source_name = ThornedArmorCard.THORNED_ARMOR_DAMAGE_SOURCE_NAME
		damage_context.add_tag(DamageContext.TAG_FOLLOW_UP)
		
		controller.apply_damage(damage_context)
	)
	
	controller.enqueue_action(action)
