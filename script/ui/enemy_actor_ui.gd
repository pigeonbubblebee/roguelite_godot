class_name EnemyActorUI
extends ActorUI

@export var _move_visual_path: NodePath
@onready var move_visual = get_node(_move_visual_path)
@export var _move_amount_path: NodePath
@onready var move_amount = get_node(_move_amount_path)

func _ready():
	super._ready()
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	if actor:
		actor.connect("move_updated", Callable(self, "update_move_display"))
		update_move_display(actor.get_next_move())
	
func update_move_display(move: ActorPremove):
	if not move:
		var tween = move_visual.create_tween()
		tween.tween_property(move_visual, "modulate:a", 0, 0.2)
		var tween2 = move_amount.create_tween()
		tween2.tween_property(move_amount, "modulate:a", 0, 0.2)
		
		return
	else:
		var tween = move_visual.create_tween()
		tween.tween_property(move_visual, "modulate:a", 1, 0.2)
		var tween2 = move_amount.create_tween()
		tween2.tween_property(move_amount, "modulate:a", 1, 0.2)
	
	move_visual.texture = move.get_icon()
	move_amount.text = str(move.get_amount())
