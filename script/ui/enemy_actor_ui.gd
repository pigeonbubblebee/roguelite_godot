class_name EnemyActorUI
extends ActorUI

signal hover_started(actorUI)
signal hover_ended(actorUI)

func _ready():
	super._ready()
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _mouse_entered():
	#print(actor.get_team_position())
	hover_started.emit(self)

func _mouse_exited():
	hover_ended.emit(self)
