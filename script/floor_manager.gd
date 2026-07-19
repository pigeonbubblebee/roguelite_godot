class_name FloorManager
extends RefCounted

var encounter_pool: Array[EncounterData]
var encounter_candidates : Array[EncounterData]
var encounter_pool_easy : Array[EncounterData]
var max_easy_pools : int
var current_easy_pools : int = 0

func load_floor_data(data : MapFloorData):
	encounter_pool = data.encounter_pool
	encounter_pool_easy = data.encounter_pool_easy
	max_easy_pools = data.max_easy_pools

func load_encounter() -> Array:
	if encounter_candidates.size() == 0:
		if current_easy_pools >= max_easy_pools:
			for e in encounter_pool:
				encounter_candidates.append(e)
		else:
			for e in encounter_pool_easy:
				encounter_candidates.append(e)
	
	var result = encounter_candidates.pick_random()
	encounter_candidates.erase(result)

	if current_easy_pools < max_easy_pools:
		current_easy_pools += 1
		if current_easy_pools == max_easy_pools:
			encounter_candidates.clear()

	return result.enemies
