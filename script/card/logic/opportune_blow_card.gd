class_name OpportuneBlowCard
extends Card

var damage : int = 30
var multistrike_amount : int = 3

var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

var status_type : String = "Debuff"

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	
	var status_effects = target.get_status_manager().get_active_status()
	
	var actual_multistrike_amount = 1
	
	for status in status_effects:
		if status.status_type == status_type:
			actual_multistrike_amount = 3
	
	for i in range(multistrike_amount):
		EffectSequenceBuilder.new(context, controller)\
			.as_card(self)\
			.damage(target, damage, damage_type)\
			.enqueue()
		
		if i < multistrike_amount - 1:
			await context.await_battle_actions()
		
	
