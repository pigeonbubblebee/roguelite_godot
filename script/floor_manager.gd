class_name FloorManager
extends RefCounted

var encounter_pool: Array[EncounterData]
var encounter_candidates : Array[EncounterData]
var encounter_candidates_elite : Array[EncounterData]
var encounter_candidates_boss : Array[EncounterData]
var encounter_pool_easy : Array[EncounterData]
var encounter_pool_elite : Array[EncounterData]
var encounter_pool_boss : Array[EncounterData]
var max_easy_pools : int
var current_easy_pools : int = 0

func load_floor_data(data : MapFloorData):
	encounter_pool = data.encounter_pool
	encounter_pool_easy = data.encounter_pool_easy
	encounter_pool_boss = data.encounter_pool_boss
	max_easy_pools = data.max_easy_pools
	encounter_pool_elite = data.encounter_pool_elite

func load_encounter() -> EncounterData:
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

	return result
	
func load_encounter_elite() -> EncounterData:
	if encounter_candidates_elite.size() == 0:
		for e in encounter_pool_elite:
			encounter_candidates_elite.append(e)
	
	var result = encounter_candidates_elite.pick_random()
	encounter_candidates_elite.erase(result)

	return result
	
func load_encounter_boss() -> EncounterData:
	if encounter_candidates_boss.size() == 0:
		for e in encounter_pool_boss:
			encounter_candidates_boss.append(e)
	
	var result = encounter_candidates_boss.pick_random()
	encounter_candidates_boss.erase(result)

	return result
