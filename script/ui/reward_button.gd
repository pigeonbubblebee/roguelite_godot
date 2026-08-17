class_name RewardButton
extends Control

@export var label_path : NodePath
@onready var label = get_node(label_path)

var reward_type : RewardType
enum RewardType { CARD, GOLD, KEY, ITEM, WEAPON }

var reward_amount = 0

signal pressed(_reward_type, _reward_amount)

var _feedback_tween: Tween
var _hovered := false

const HOVER_SCALE := Vector2(1.05, 1.05)
const NORMAL_SCALE := Vector2.ONE
var has_button_feedback := true

const HOVER_TIME := 0.1

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	pivot_offset = size / 2.0

func change_text():
	if reward_type == RewardType.CARD:
		label.text = "Add a Card"
	elif reward_type == RewardType.GOLD:
		label.text = "Add %s Gold" % [reward_amount]
	elif reward_type == RewardType.KEY:
		label.text = "Add a Key"
	elif reward_type == RewardType.ITEM:
		label.text = "Add a Item"
	elif reward_type == RewardType.WEAPON:
		label.text = "Swap Weapon"

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			pressed.emit(reward_type, reward_amount)
			
			queue_free()

func _on_mouse_entered():
	_hovered = true
	
	if not has_button_feedback:
		return
	
	_play_feedback_tween(HOVER_SCALE, HOVER_TIME)


func _on_mouse_exited():
	_hovered = false
	
	if not has_button_feedback:
		return
	
	_play_feedback_tween(NORMAL_SCALE, HOVER_TIME)

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
