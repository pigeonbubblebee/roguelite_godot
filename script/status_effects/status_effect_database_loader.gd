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
			"ICON_TYPE": info["ICON_TYPE"]
		}

		status_effects[status_id] = status
		
func get_status_effect(status_id: String) -> Dictionary:
	return status_effects.get(status_id, null)
