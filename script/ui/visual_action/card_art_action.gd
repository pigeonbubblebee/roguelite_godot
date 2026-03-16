class_name CardArtAction
extends BattleVisualAction

var card_id: String
var target_actor: Actor

var length : float

func _init(actor, _card_id: String, _length : float = 0.3):
	target_actor = actor
	card_id = _card_id
	
	length = _length

func execute(scene: BattleScene):
	var actor_ui = scene.request_ui_from_actor(target_actor)

	if not actor_ui:
		push_warning("No actor ui found for CardArtAction")
		finished.emit()
		return

	started.emit()

	# Load card art (adjust this path to match your project)
	var texture: Texture2D = load("res://assets/card_art/%s.png" % card_id)

	if not texture:
		push_warning("Card art not found for id: " + card_id)
		finished.emit()
		return

	var sprite := Sprite2D.new()
	sprite.texture = texture
	
	var center = actor_ui.global_position + (actor_ui.size / 2)
	
	sprite.global_position = center
	sprite.centered = true

	scene.add_child(sprite)

	# Fade out tween
	var tween = scene.create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, length)
	tween.parallel().tween_property(sprite, "position:y", sprite.position.y - 10, length)

	tween.finished.connect(func():
		sprite.queue_free()
		finished.emit()
	)
