extends ItemStatusEffect

func on_battle_start(context: BattleContext, controller:BattleController):
	context.multistrike_bonus += 1
