class_name CardDatabaseLoader
extends Node

var cards : Dictionary = {}

func _ready():
	load_cards("res://data/sheets/Roguelite.json")

func load_cards(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()

	var parsed = JSON.parse_string(json_text)

	if parsed == null:
		push_error("Failed to parse card JSON")
		return

	var card_info = parsed["CardFinal"]
	var scaling_data = parsed["ScalingValues"]

	for card_id in card_info.keys():

		var info = card_info[card_id]

		var card = {
			"CARD_ID": card_id,
			"CARD_NAME": info["CARD_NAME"],
			"DESCRIPTION": info["DESCRIPTION"],
			"COST": info["COST"],
			"RARITY": info["RARITY"],
			"SCALING": {}
		}

		if scaling_data.has(card_id):
			for stat in scaling_data[card_id].keys():
				var value = scaling_data[card_id][stat]

				if value == null:
					card["SCALING"][stat] = "N/A"
				else:
					card["SCALING"][stat] = value

		cards[card_id] = card
		
func get_card(card_id: String) -> Dictionary:
	if(not cards.has(card_id)):
		push_error("Cannot find card: " + card_id)
	return cards.get(card_id, null)
	
func get_scaling(card_id: String, stat: String):
	if !cards.has(card_id):
		return "N/A"

	var scaling = cards[card_id]["SCALING"]

	if !scaling.has(stat):
		return "N/A"

	return scaling[stat]

func get_all_scaling(card_id: String) -> String:
	if !cards.has(card_id):
		return "N/A"

	var scaling = cards[card_id]["SCALING"]
	var parts = []

	for stat in scaling.keys():
		var value = scaling[stat]

		if value != "N/A":
			parts.append("%s (%s)" % [stat, value])
			
	if parts.size() == 0:
		return "N/A"

	return ", ".join(parts)
