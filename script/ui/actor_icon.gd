extends Control

@export var _icon_path: NodePath
@onready var icon = get_node(_icon_path)

@export var _av_text_path: NodePath
@onready var av_text: Label = get_node(_av_text_path)

@export var _border_path: NodePath
@export var _default_border_texture: Texture2D
@export var _highlighted_border_texture: Texture2D
@onready var border: NinePatchRect = get_node(_border_path)

var _actor: Actor
var displayed_av: float

func _ready() -> void:
	border.texture = _default_border_texture

func update_actor(actor: Actor, active: bool) -> void:
	_actor = actor
	icon.texture = actor.get_texture()
	if displayed_av == 0 || displayed_av < actor.get_remaining_av():
		displayed_av = actor.get_remaining_av()
	
	border.texture = _default_border_texture if !active else _highlighted_border_texture

func _process(delta):
	if _actor:
		displayed_av = lerp(displayed_av, _actor.get_remaining_av(), delta*5)
		av_text.text = "%.2f" % displayed_av
