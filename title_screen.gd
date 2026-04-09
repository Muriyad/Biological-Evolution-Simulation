extends Control
	

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")
	pass

func _on_circle_count_value_changed(value):
	$CircleCountLabel.text = "Organism Count: " + str(int(value))
	Global.circleCount = value
	pass 


func _on_size_bias_value_changed(value):
	$SizeBiasLabel.text = "Size Bias: " + str(int(value))
	Global.sizeBias = value
	pass


func _on_number_of_generations_value_changed(value):
	$NumberOfGenerationsLabel.text = "Number of Generations: " + str(int(value))
	Global.numGenerations = value
	pass


func _on_pellets_needed_value_changed(value):
	$PelletsNeededLabel.text = "Pellets Needed to Survive: " + str(int(value))
	Global.pelletsNeeded = value
	pass


func _on_info_button_pressed() -> void:
	get_tree().change_scene_to_file("res://info_screen.tscn")
