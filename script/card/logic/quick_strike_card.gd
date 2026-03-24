class_name QuickStrikeCard
extends Card

var damage : int = 40
var multistrike_amount : int = 2
var damage_type : DamageType.Type = DamageType.Type.PHYSICAL

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	
	for i in range(multistrike_amount):
		EffectSequenceBuilder.new(context, controller)\
			.as_card(self)\
			.damage(target, damage, damage_type)\
			.enqueue()
		
		if i < multistrike_amount - 1:
			await context.await_battle_actions()
	
