class_name RewardButton
extends Control

@export var label_path : NodePath
@onready var label = get_node(label_path)

var reward_type : RewardType
enum RewardType { CARD, GOLD, KEY, ITEM }

var reward_amount = 0

signal pressed(_reward_type, _reward_amount)

func change_text():
	if reward_type == RewardType.CARD:
		label.text = "Add a Card"
	elif reward_type == RewardType.GOLD:
		label.text = "Add %s Gold" % [reward_amount]
	elif reward_type == RewardType.KEY:
		label.text = "Add a Key"
	elif reward_type == RewardType.ITEM:
		label.text = "Add a Item"

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			pressed.emit(reward_type, reward_amount)
			
			queue_free()
