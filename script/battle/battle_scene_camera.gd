class_name BattleSceneCamera
extends Camera2D

var shake_magnitude := 0.0
var shake_time_left := 0.0
var original_position := Vector2.ZERO

func _ready():
	original_position = position

func _process(delta):
	if shake_time_left > 0:
		shake_time_left -= delta
		
		# Random offset each frame
		var offset_x = randf_range(-shake_magnitude, shake_magnitude)
		var offset_y = randf_range(-shake_magnitude, shake_magnitude)
		
		offset_x = correct_offset(offset_x)
		offset_y = correct_offset(offset_y)
		
		position = original_position + Vector2(offset_x, offset_y)
	else:
		position = original_position
		
func correct_offset(value: float) -> float:
	if value > 0:
		value = ceil(value)
	elif value < 0:
		value = floor(value)
		
	return value


func add_trauma(magnitude: float = 2, duration: float = 0.08) -> void:
	shake_magnitude = magnitude
	shake_time_left = duration
