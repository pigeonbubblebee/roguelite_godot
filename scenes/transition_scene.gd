class_name TransitionScene
extends CanvasLayer

signal covered

@export var room_transition_1_path : NodePath
@onready var room_transition_1 = get_node(room_transition_1_path)

@export var room_transition_2_path : NodePath
@onready var room_transition_2 = get_node(room_transition_2_path)

var starting_position_1 = Vector2(0, 360)
var starting_position_2 = Vector2(0, -360)

var desired_position_1 = Vector2(0, 160)
var desired_position_2 = Vector2(0, -160)

@onready var center = Vector2(320, 180)

var timer = 0.3

func _ready():
	room_transition_1.position = center + starting_position_1
	room_transition_2.position = center + starting_position_2
	
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		room_transition_1,
		"position",
		center + desired_position_1,
		timer
	)
	
	tween.tween_property(
		room_transition_2,
		"position",
		center + desired_position_2,
		timer
	)
	
	tween.finished.connect(func():
		covered.emit()
	)


func uncover():
	
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		room_transition_1,
		"position",
		center + starting_position_1,
		timer
	)
	
	tween.tween_property(
		room_transition_2,
		"position",
		center + starting_position_2,
		timer
	)
	
	tween.finished.connect(func():
		queue_free()
	)
