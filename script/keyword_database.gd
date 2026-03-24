extends Node

var keywords : Dictionary = {}

func _ready():
	load_keywords("res://data/sheets/Roguelite.json")

func load_keywords(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()

	var parsed = JSON.parse_string(json_text)

	if parsed == null:
		push_error("Failed to parse card JSON")
		return

	var keyword_info = parsed["Keywords"]

	for keyword_id in keyword_info.keys():
		var info = keyword_info[keyword_id]

		var keyword = {
			"KEYWORD_ID": keyword_id,
			"KEYWORD_NAME": info["KEYWORD_NAME"],
			"DESCRIPTION": info["DESCRIPTION"]
		}
			
		keywords[keyword_id] = keyword
		
func get_keyword(keyword_id: String) -> Dictionary:
	if(not keywords.has(keyword_id)):
		push_error("Cannot find keyword: " + keyword_id)
		
	return keywords.get(keyword_id, null)
