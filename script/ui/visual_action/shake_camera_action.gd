class_name ShakeCameraAction
extends BattleVisualAction

# shake strength in pixels
var strength: float = 2
var duration: float = 0.08

func _init(_strength : float = 2, _duration = 0.08):
	strength = _strength
	duration = _duration

func execute(scene: BattleScene):
	var cam = scene.get_camera()
	if not cam:
		push_warning("No camera found for ScreenShakeAction")
		emit_signal("finished")
		return
	
	#cam.finished_shaking.connect(_on_shake_finished, CONNECT_ONE_SHOT)
	cam.add_trauma(strength, duration)
	
	await scene.get_tree().create_timer(duration).timeout 
	
	emit_signal("finished")
