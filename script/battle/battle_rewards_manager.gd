class_name BattleRewardsManager
extends RefCounted

var current_items : Array

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

func generate_item_rewards(ctx) -> Array:
	var pool = ItemDatabase.get_all_valid_items()
	var filtered_pool = pool.filter(func(dict): 
		var contains := false
		for i in current_items:
			if i["ITEM_ID"] == dict["ITEM_ID"]:
				contains = true
		return (not contains) and (not dict["NOT_DRAFTABLE"])
	)
	filtered_pool.shuffle()
	return filtered_pool.slice(0, 3)

func bind_items(arr : Array):
	current_items = arr
