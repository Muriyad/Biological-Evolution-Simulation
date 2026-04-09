extends Area2D

class_name Pellet

func _on_body_entered(body):
	if body is circle:
		Global.pelletCount-=1
		body._on_area_entered(self)
		queue_free()
	pass
