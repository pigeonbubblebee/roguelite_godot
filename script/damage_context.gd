class_name DamageContext
extends RefCounted

var source_name: String
var damage: int
var blast_damage: int
var hit_actors: Array[Actor]
# Scaling should be calculated once then divided based on this
var multi_strike_amount: int
var damage_type: DamageType.Type
var source_faction: Faction.Type
