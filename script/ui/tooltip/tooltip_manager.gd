extends Node2D

var tooltip_scene : PackedScene = preload("res://scenes/tooltip.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TooltipRequestBus.request_tooltip_signal.connect(_on_request_tooltip)

func _on_request_tooltip(data : TooltipData):
	var tooltip = tooltip_scene.instantiate()
	
	add_child(tooltip)
	
	tooltip.starting_position = data.starting_position
	tooltip.offset = data.offset
	tooltip.set_description(data.description)
	
	tooltip.set_keywords(data.keywords)
	
	tooltip.resizeable = data.resizeable
	
	data.event_bus.connect(data.hide_event_hook, 
		Callable(tooltip, "hide_tooltip"))
	
	tooltip.show_tooltip()
