class_name StatusEffectIcon
extends Control

@export var _icon_path: NodePath
@onready var icon = get_node(_icon_path)
@export var _stacks_label_path: NodePath
@onready var stacks_label = get_node(_stacks_label_path)
