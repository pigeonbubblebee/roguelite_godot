class_name BattleRewardsManager
extends RefCounted

var current_items : Array
var current_weapon

func generate_card_rewards(ctx, amount := 3) -> Array:
	var pool = CardDatabase.get_all_valid_cards()
	var c_pool = pool.filter(func(dict):
		return dict["RARITY"] == "COMMON" and (not dict["NOT_DRAFTABLE"])
	)
	var r_pool = pool.filter(func(dict):
		return dict["RARITY"] == "RARE" and (not dict["NOT_DRAFTABLE"])
	)

	c_pool.shuffle()
	r_pool.shuffle()

	var rare_chance: float = ctx.added_rare_pool_chance

	var guaranteed_rares := int(floor(rare_chance))
	var fractional_rare_chance := rare_chance - guaranteed_rares

	var rare_count := guaranteed_rares

	if randf() < fractional_rare_chance:
		rare_count += 1

	# Don't add more rare cards than there are reward slots.
	rare_count = min(rare_count, amount)

	var reward_pool := r_pool.slice(0, rare_count) + c_pool.slice(0, amount - rare_count)
	reward_pool.shuffle()

	return reward_pool

func generate_item_rewards(ctx) -> Array:
	var pool = ItemDatabase.get_all_valid_items()
	var filtered_pool = pool.filter(func(dict): 
		var contains := false
		for i in current_items:
			if i["ITEM_ID"] == dict["ITEM_ID"]:
				contains = true
		return (not contains) and (not dict["NOT_DRAFTABLE"]) and (not dict["WEAPON"])
	)
	filtered_pool.shuffle()
	return filtered_pool.slice(0, 3)

func generate_weapon_rewards(ctx) -> Array:
	var pool = ItemDatabase.get_all_valid_items()
	var filtered_pool = pool.filter(func(dict): 
		return ((not current_weapon["ITEM_ID"] == dict["ITEM_ID"]) 
				and (not dict["NOT_DRAFTABLE"]) 
				and (dict["WEAPON"]))
	)
	filtered_pool.shuffle()
	return filtered_pool.slice(0, 3)

func bind_items(arr : Array, weapon):
	current_items = arr
	current_weapon = weapon
