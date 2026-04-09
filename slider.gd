extends Control

func _ready():
	$HSlider.value = Global.speed

func _on_h_slider_value_changed(value):
	Global.speed = value
	if(Global.speed==$HSlider.get_max()):
		$Label.text = "speed factor: ∞"
		Engine.set_time_scale(1000)
		Engine.set_physics_ticks_per_second(1000*60)
	else:
		$Label.text = "speed factor: " + str(int(Global.speed))
		Engine.set_time_scale(Global.speed)
		Engine.set_physics_ticks_per_second(Global.speed*60)
