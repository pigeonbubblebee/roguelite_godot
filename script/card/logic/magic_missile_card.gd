class_name MagicMissileCard
extends Card

var damage : int = 45
var multistrike_amount : int = 3
var damage_type : DamageType.Type = DamageType.Type.MAGIC

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var selected_enemys = context.get_selected_enemies_aoe()
	
	for i in range(multistrike_amount):
		var target = selected_enemys.pick_random()
		
		EffectSequenceBuilder.new(context, controller)\
			.as_card(self)\
			.damage(target, damage, damage_type)\
			.enqueue()
		
		if i < multistrike_amount - 1:
			await context.await_battle_actions()

func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_aoe(total_targets, target_index)
