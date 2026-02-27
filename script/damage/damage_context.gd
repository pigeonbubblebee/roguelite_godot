class_name DamageContext
extends RefCounted

var source_name: String
# Actual name of the damage provider, i e card name, status effect name, FuA name
var damage_owner # Actor, Status Effect, Ect.
# FuA, Status effects by player, Cards should all have player as damage owner
var damage: int
var blast_damage: int
var hit_actors: Array[Actor]
# Scaling should be calculated once then divided based on this
var multi_strike_amount: int
var damage_type: DamageType.Type
var source_faction: Faction.Type
var modifiers : DamageModifiers

func _init():
	modifiers = DamageModifiers.new()
	
func add_damage_percent(amp: float):
	for actor in hit_actors:
		if actor in modifiers.damage_percent_dictionary:
			modifiers.damage_percent_dictionary[actor] += amp
		else:
			modifiers.damage_percent_dictionary[actor] = amp
	
func calculate_damage() -> Dictionary:
	var float_damage = float(damage)
	var float_blast_damage = float(blast_damage)
	
	var final_damage_dictionary : Dictionary
	
	for i in range(hit_actors.size()):
		var position_damage = float_damage	if i == 0 else float_blast_damage
		var vuln_bonus = 0
		var damage_percent_bonus = 0
		var hit_actor = hit_actors[i]
		
		if hit_actor in modifiers.damage_percent_dictionary:
			damage_percent_bonus = modifiers.damage_percent_dictionary[hit_actor]
		if hit_actor in modifiers.vulnerability_dictionary:
			vuln_bonus = modifiers.vulnerability_dictionary[hit_actor]
		
		var final_damage = position_damage * (damage_percent_bonus + 1) * (vuln_bonus + 1)
				
		final_damage_dictionary[hit_actor] = int(ceil(final_damage))
		
	return final_damage_dictionary
