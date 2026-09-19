extends ItemStatusEffect

var damage_percent_bonus = 0.1

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		var multi = floor(battle_context.get_player().get_armor() / 50)
		context.add_damage_percent(damage_percent_bonus * multi)
