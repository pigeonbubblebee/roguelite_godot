class_name StatusEffectIcon
extends Control

@export var _icon_path: NodePath
@onready var icon = get_node(_icon_path)
@export var _stacks_label_path: NodePath
@onready var stacks_label = get_node(_stacks_label_path)

var status_effect : StatusEffect

signal hover_started(status)
signal hover_ended(status)

func _ready():
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _mouse_entered():
	hover_started.emit(status_effect)

func _mouse_exited():
	hover_ended.emit(status_effect)
