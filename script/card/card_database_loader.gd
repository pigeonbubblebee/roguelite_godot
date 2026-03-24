class_name CardDatabaseLoader
extends Node

var cards : Dictionary = {}

const ART_PATH := "res://assets/card_art/"
const SCRIPT_PATH := "res://script/card/logic/"
const RESOURCE_PATH := "res://data/card/"

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
			"SCALING": {},
			"TYPE": Card.get_string_as_card_type(info["TYPE"]),
			"TEXTURE": null,
			"SCRIPT": null,
			"RESOURCE": null,
			"KEYWORDS": []
		}
		
		# Keywords
		
		var keywords : Array[String] = []
		
		if info["KEYWORDS"]:
			var split = info["KEYWORDS"].split(';')
			
			for s in split:
				keywords.append(s)
		
		card["KEYWORDS"] = keywords
		
		# Scaling Data

		if scaling_data.has(card_id):
			for stat in scaling_data[card_id].keys():
				var value = scaling_data[card_id][stat]

				if value == null:
					card["SCALING"][stat] = "N/A"
				else:
					card["SCALING"][stat] = value
					
		# Loads card art
		var art_path = ART_PATH + card_id + ".png"

		if ResourceLoader.exists(art_path):
			card["TEXTURE"] = load(art_path)
		else:
			push_warning("Missing card art for: " + card_id)

		# Loads card script
		var script_path = SCRIPT_PATH + card_id + ".gd"

		if ResourceLoader.exists(script_path):
			card["SCRIPT"] = load(script_path)
		else:
			push_warning("Missing card script for: " + card_id)
			
		# Loads card resource
		var resource_path = RESOURCE_PATH + card_id + ".tres"

		if ResourceLoader.exists(resource_path):
			card["RESOURCE"] = load(resource_path)
		else:
			push_warning("Missing card resource for: " + card_id)
			
		cards[card_id] = card
		
func get_card(card_id: String) -> Dictionary:
	if(not cards.has(card_id)):
		push_error("Cannot find card: " + card_id)
	return cards.get(card_id, null)

func get_all_valid_cards() -> Array:
	var res = []
	for card in cards:
		var dic = get_card(card)
		
		if not dic:
			continue
		
		if not (dic["TEXTURE"] && dic["SCRIPT"]):
			continue
		
		res.append(dic)
		
	return res
	
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
