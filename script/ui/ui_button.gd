class_name UIButton
extends Control

signal pressed

var disabled := false
@export var one_shot := false
@export var has_button_feedback := true

var _feedback_tween: Tween
var _hovered := false

const HOVER_SCALE := Vector2(1.05, 1.05)
const PRESSED_SCALE := Vector2(0.95, 0.95)
const NORMAL_SCALE := Vector2.ONE

const HOVER_TIME := 0.1
const CLICK_TIME := 0.06
const RELEASE_TIME := 0.1


func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	pivot_offset = size / 2.0


func _gui_input(event):
	if disabled:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if has_button_feedback:
				_play_click_feedback()
			
			pressed.emit()
			
			if one_shot:
				disabled = true


func _on_mouse_entered():
	_hovered = true
	
	if not has_button_feedback or disabled:
		return
	
	_play_feedback_tween(HOVER_SCALE, HOVER_TIME)


func _on_mouse_exited():
	_hovered = false
	
	if not has_button_feedback:
		return
	
	_play_feedback_tween(NORMAL_SCALE, HOVER_TIME)


func _play_click_feedback():
	if _feedback_tween:
		_feedback_tween.kill()
	
	_feedback_tween = create_tween()
	_feedback_tween.set_trans(Tween.TRANS_QUAD)
	_feedback_tween.set_ease(Tween.EASE_OUT)
	
	_feedback_tween.tween_property(
		self,
		"scale",
		PRESSED_SCALE,
		CLICK_TIME
	)
	
	_feedback_tween.tween_property(
		self,
		"scale",
		HOVER_SCALE if _hovered else NORMAL_SCALE,
		RELEASE_TIME
	)


func _play_feedback_tween(target_scale: Vector2, duration: float):
	if _feedback_tween:
		_feedback_tween.kill()
	
	_feedback_tween = create_tween()
	_feedback_tween.set_trans(Tween.TRANS_QUAD)
	_feedback_tween.set_ease(Tween.EASE_OUT)
	_feedback_tween.tween_property(
		self,
		"scale",
		target_scale,
		duration
	)
