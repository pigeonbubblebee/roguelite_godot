extends Node

var items : Dictionary = {}

const ART_PATH := "res://assets/item_art/"
const SCRIPT_PATH := "res://script/item/logic/"
const DEFAULT_SCRIPT_PATH := "res://script/item/item.gd"

func _ready():
	load_items("res://data/sheets/Roguelite.json")

func load_items(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()

	var parsed = JSON.parse_string(json_text)

	if parsed == null:
		push_error("Failed to parse card JSON")
		return

	var item_info = parsed["ItemFinal"]
	var scaling_data = parsed["ScalingValues"]

	for item_id in item_info.keys():
		var info = item_info[item_id]

		var item = {
			"ITEM_ID": item_id,
			"ITEM_NAME": info["ITEM_NAME"],
			"DESCRIPTION": info["DESCRIPTION"],
			"NOT_DRAFTABLE": true if info["NOT_DRAFTABLE"] else false,
			"SCALING": {},
			"TEXTURE": null,
			"WEAPON": true if info["WEAPON"] else false,
			"SCRIPT": null
		}
		
		# Keywords
		#var keywords : Array[String] = []
		
		#if info["KEYWORDS"]:
		#	var split = info["KEYWORDS"].split(';')
			
		#	for s in split:
		#		keywords.append(s)
		
		#card["KEYWORDS"] = keywords
		
	#	var keywords_upgraded : Array[String] = []
		
		# Scaling Data

		if scaling_data.has(item_id):
			for stat in scaling_data[item_id].keys():
				var value = scaling_data[item_id][stat]

				if value == null:
					item["SCALING"][stat] = 0
				else:
					item["SCALING"][stat] = int(value)
					
		# Loads card art
		var art_path = ART_PATH + item_id + ".png"

		if ResourceLoader.exists(art_path):
			item["TEXTURE"] = load(art_path)
		else:
			push_warning("Missing item art for: " + item_id)

		# Loads card script
		var script_path = SCRIPT_PATH + item_id + ".gd"

		if ResourceLoader.exists(script_path):
			item["SCRIPT"] = load(script_path)
		else:
			item["SCRIPT"] = load(DEFAULT_SCRIPT_PATH)
			
		# Loads card resource
			
		items[item_id] = item
		
func get_item(item_id: String) -> Dictionary:
	if(not items.has(item_id)):
		push_error("Cannot find item: " + item_id)
	return items.get(item_id, null)
	
func get_attributes(item_id: String, stat: String):
	if !items.has(item_id):
		return 0

	var scaling = items[item_id]["SCALING"]

	if !scaling.has(stat):
		return 0

	return scaling[stat]
	
func get_attributes_as_dic(item_id: String):
	if !items.has(item_id):
		return null

	var scaling = items[item_id]["SCALING"]

	return scaling

func get_all_attributes(item_id: String) -> String:
	if !items.has(item_id):
		return "Neutral"

	var scaling = items[item_id]["SCALING"]
	var parts = []

	for stat in scaling.keys():
		var value = scaling[stat]

		if value != 0:
			parts.append("%s (%s)" % [stat, value])
			
	if parts.size() == 0:
		return "Neutral"

	return ", ".join(parts)
	
func get_all_valid_items() -> Array:
	var res = []
	for item in items:
		var dic = get_item(item)
		
		if not dic:
			continue
		
		if not (dic["TEXTURE"] && dic["SCRIPT"]):
			continue
		
		res.append(dic)
		
	return res
