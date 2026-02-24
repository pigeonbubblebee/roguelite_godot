extends Label

var delay = 0.15

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	#tween.tween_property(self, "scale", Vector2(0.7, 0.7), 0.2)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_delay(delay)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5).set_delay(0.2 + delay)
	
	tween.tween_property(self, "position:y", global_position.y - 20, 1.3).set_delay(delay)
	await tween.finished
	queue_free()

func bind(amt, ctx):
	text = str(amt)
	KeywordFormatter.format_damage_text(self, ctx)
