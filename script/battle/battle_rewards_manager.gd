class_name BattleRewardsManager
extends RefCounted

func generate_card_rewards(ctx) -> Array:
	var pool = CardDatabase.get_all_valid_cards()
	pool = pool.filter(func(dict): return not dict["NOT_DRAFTABLE"])
	pool.shuffle()
	return pool.slice(0, 3)
