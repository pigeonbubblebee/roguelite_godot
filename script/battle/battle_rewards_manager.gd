class_name BattleRewardsManager
extends RefCounted

func generate_card_rewards(ctx) -> Array:
	var pool = CardDatabase.get_all_valid_cards()
	var c_pool = pool.filter(func(dict): return dict["RARITY"] == "COMMON" and (not dict["NOT_DRAFTABLE"]))
	var r_pool = pool.filter(func(dict): return dict["RARITY"] == "RARE" and (not dict["NOT_DRAFTABLE"]))
	c_pool.shuffle()
	r_pool.shuffle()
	
	var rare_reward = (r_pool.slice(0,1) + c_pool.slice(0,2))
	rare_reward.shuffle()
	
	if randf() < 0.34 + ctx.added_rare_pool_chance:
		return rare_reward
	return c_pool.slice(0, 3)
