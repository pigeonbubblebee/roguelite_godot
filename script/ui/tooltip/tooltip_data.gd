class_name TooltipData
extends RefCounted

var description : String
var starting_position : Vector2 = Vector2(0, 0)
var offset : Vector2 = Vector2(0, -103)

var event_bus
var hide_event_hook

var resizeable := false

var keywords : Array[String]

func add_description(desc : String) -> TooltipData:
	description = desc
	return self
	
func add_starting_position(_starting_position : Vector2) -> TooltipData:
	starting_position = _starting_position
	return self

func add_offset(_offset : Vector2) -> TooltipData:
	offset = _offset
	return self

func add_hide_event(_event_bus, event_hook_name : String) -> TooltipData:
	event_bus = _event_bus
	hide_event_hook = event_hook_name
	return self

func add_keywords(_keywords : Array[String]) -> TooltipData:
	for kw in _keywords:
		keywords.append(kw)
		
	return self

func set_resizable(_resizable : bool) -> TooltipData:
	resizeable = _resizable
		
	return self
