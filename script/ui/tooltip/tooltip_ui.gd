class_name TooltipUI
extends Node2D

@export var _tooltip_label_path : NodePath
@onready var tooltip_label = get_node(_tooltip_label_path)

var starting_position : Vector2
var offset : Vector2

var tooltip_tween : Tween

var sub_tooltips : Array[Control]

@export var _control_path : NodePath
@onready var control = get_node(_control_path)

@export var _subtooltip_container_path : NodePath
@onready var _subtooltip_container = get_node(_subtooltip_container_path)

var resizeable = false

var default_height = 90

signal tooltip_hide_request

var tooltip_scene : PackedScene = preload("res://scenes/subtooltip.tscn")

func set_description(text : String):
	tooltip_label.text = text

func show_tooltip(reposition : bool = true):
	if tooltip_tween:
		tooltip_tween.kill()
		
	if reposition:
		global_position = starting_position	
			
		tooltip_tween = create_tween()
		tooltip_tween.tween_property(self, "global_position", 
			starting_position + offset, 0.12)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	resize()
		
	self.visible = true	

func hide_tooltip():
	if tooltip_tween:
		tooltip_tween.kill()
	
	# maybe add anim, not sure
		
	self.visible = false	
	global_position = starting_position	
	
	tooltip_hide_request.emit()
	
	queue_free()

func set_keywords(keywords : Array[String]):
	if (starting_position + offset).x < 0:
		_subtooltip_container.position.x = control.size.x + 4
	else:
		_subtooltip_container.position.x = -(control.size.x + 4)
	
	for keyword in keywords:
		var dic = KeywordDatabase.get_keyword(keyword)
		var desc = dic["DESCRIPTION"]
		var k_name = dic["KEYWORD_NAME"]
		load_subtooltip(k_name + ": " + desc)

func resize():
	if not resizeable:
		control.size.y = 90
		control.position.y = -control.size.y
		
		return
	
	var text_size = tooltip_label.get_minimum_size().y
	
	control.size.y = text_size + 8
	control.position.y = -control.size.y

func load_subtooltip(keyword) -> Node:
	var tooltip = tooltip_scene.instantiate()
	
	_subtooltip_container.add_child(tooltip)
	
	tooltip.set_description(keyword)
	
	self.connect("tooltip_hide_request", 
		Callable(tooltip, "hide_tooltip"))
	
	tooltip.show_tooltip()
	
	return tooltip
