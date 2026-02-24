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
var _av_tween: Tween

func _ready() -> void:
	border.texture = _default_border_texture

func update_actor(actor: Actor, active: bool) -> void:
	_actor = actor
	icon.texture = actor.get_texture()

	var new_av = actor.get_remaining_av()
	if _av_tween:
		_av_tween.kill()

	_av_tween = create_tween()
	_av_tween.tween_property(self, "displayed_av", new_av, 0.4)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	border.texture = _default_border_texture if !active else _highlighted_border_texture

func _process(delta):
	if _actor:
		av_text.text = "%.2f" % displayed_av
