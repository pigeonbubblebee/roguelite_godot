class_name BattleRewardsManager
extends RefCounted

var current_items : Array
var current_weapon

var current_attributes

func generate_card_rewards(ctx, amount := 4) -> Array:
	var pool = CardDatabase.get_all_valid_cards().filter(func(dict):
		return (
			dict["RARITY"] == "COMMON"
			and not dict["NOT_DRAFTABLE"]
		)
	)

	# Get stats sorted from highest to lowest.
	var sorted_stats: Array[String] = []
	for stat in current_attributes:
		sorted_stats.append(stat)

	sorted_stats.sort_custom(func(a, b):
		return current_attributes[a] > current_attributes[b]
	)

	# No stats at all.
	if sorted_stats.is_empty():
		pool.shuffle()
		return pool.slice(0, amount)

	var highest_stat = sorted_stats[0]

	# If the highest stat is 0, there is effectively no highest stat.
	if current_attributes[highest_stat] <= 0:
		pool.shuffle()
		return pool.slice(0, amount)

	# Group cards by primary attribute.
	var stat_pools := {}

	for stat in sorted_stats:
		stat_pools[stat] = []

	var random_pool: Array = []

	for card in pool:
		var stat = card["PRIMARY_STAT"]

		if stat == "" or not stat_pools.has(stat):
			random_pool.append(card)
		else:
			stat_pools[stat].append(card)

	for stat in stat_pools:
		stat_pools[stat].shuffle()

	random_pool.shuffle()

	var rewards: Array = []

	# Only one stat has points.
	if sorted_stats.size() == 1 or current_attributes[sorted_stats[1]] <= 0:
		rewards.append_array(stat_pools[highest_stat].slice(0, 2))
		
		var remaining = amount - rewards.size()
		rewards.append_array(random_pool.slice(0, remaining))

	# Two or more stats have points.
	else:
		var second_stat = sorted_stats[1]

		# 1 from highest.
		rewards.append_array(stat_pools[highest_stat].slice(0, 1))

		# 1 from second highest.
		rewards.append_array(stat_pools[second_stat].slice(0, 1))

		# 1 from either highest or second highest.
		var top_pool: Array = stat_pools[highest_stat] + stat_pools[second_stat]
		top_pool.shuffle()
		rewards.append_array(top_pool.slice(0, 1))

		# 1 from a random stat that isn't top two.
		var lower_pool: Array = []

		for stat in sorted_stats.slice(2):
			lower_pool.append_array(stat_pools[stat])

		# Also allow untyped cards into the random slot.
		lower_pool.append_array(random_pool)

		lower_pool.shuffle()
		rewards.append_array(lower_pool.slice(0, 1))

	# If a particular stat doesn't have enough cards, fill missing slots randomly.
	if rewards.size() < amount:
		var remaining_pool = pool.filter(func(card):
			return not rewards.has(card)
		)
		remaining_pool.shuffle()
		rewards.append_array(remaining_pool.slice(0, amount - rewards.size()))

	rewards.shuffle()
	return rewards.slice(0, amount)
	
func generate_item_rewards(ctx, amt := 3) -> Array:
	var pool = ItemDatabase.get_all_valid_items()
	var filtered_pool = pool.filter(func(dict): 
		var contains := false
		for i in current_items:
			if i["ITEM_ID"] == dict["ITEM_ID"]:
				contains = true
		return (not contains) and (not dict["NOT_DRAFTABLE"]) and (not dict["WEAPON"])
	)
	filtered_pool.shuffle()
	return filtered_pool.slice(0, amt)

func generate_weapon_rewards(ctx, amt := 3) -> Array:
	var pool = ItemDatabase.get_all_valid_items()
	var filtered_pool = pool.filter(func(dict): 
		return ((not current_weapon["ITEM_ID"] == dict["ITEM_ID"]) 
				and (not dict["NOT_DRAFTABLE"]) 
				and (dict["WEAPON"]))
	)
	filtered_pool.shuffle()
	return filtered_pool.slice(0, amt)

func bind_attributes(attributes : Dictionary):
	current_attributes = attributes

func bind_items(arr : Array, weapon):
	current_items = arr
	current_weapon = weapon
