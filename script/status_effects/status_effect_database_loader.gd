class_name StatusEffectDatabaseLoader
extends Node

var status_effects : Dictionary = {}

func _ready():
	load_status("res://data/sheets/Roguelite.json")

func load_status(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()

	var parsed = JSON.parse_string(json_text)

	if parsed == null:
		push_error("Failed to parse JSON")
		return

	var status_info = parsed["StatusEffects"]

	for status_id in status_info.keys():
		var info = status_info[status_id]

		var status = {
			"STATUS_EFFECT_ID": status_id,
			"STATUS_EFFECT_NAME": info["STATUS_NAME"],
			"DESCRIPTION": info["DESCRIPTION"],
			"ICON_TYPE": info["ICON_TYPE"],
			"STATUS_TYPE": info["STATUS_TYPE"]
		}

		status_effects[status_id] = status
		
	var item_info = parsed["ItemFinal"]

	for item_id in item_info.keys():
		var info = item_info[item_id]

		var status = {
			"STATUS_EFFECT_ID": item_id + "_status",
			"STATUS_EFFECT_NAME": info["ITEM_NAME"],
			"DESCRIPTION": info["DESCRIPTION"],
			"ICON_TYPE": "general_buff",
			"STATUS_TYPE": "Buff"
		}

		status_effects[item_id + "_status"] = status
		
func get_status_effect(status_id: String) -> Dictionary:
	return status_effects.get(status_id, null)
