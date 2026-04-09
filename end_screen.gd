extends Control

func sum(accum, number):
	return accum + number

func _ready():
	var info = "Generation: {gen}\n\nList of Final Circle Sizes: {sizes}\n\nAverage Initial Circle Size: {avgInit}\n\nAverage Final Circle Size: {avgFin}"
	var averageInitialSize = Global.initialCircleSizes.reduce(sum, 0)/Global.initialCircleSizes.size()
	var averageFinalSize = Global.circleSizes.reduce(sum, 0)/Global.circleSizes.size()
	$Info.text = info.format({"gen": str(Global.generation,"/",Global.numGenerations), "sizes": Global.circleSizes, "avgInit": averageInitialSize, "avgFin": averageFinalSize})


func _on_reset_button_pressed():
	Global.circleAte = []
	Global.circleSizes = []
	Global.pelletCount = 0
	Global.generation = 1
	Global.survivingCircles = []
	Global.reset = false
	Global.circlesCleared = false
	
	Global.circleCount = 10
	Global.sizeBias = 50
	Global.numGenerations = 100
	Global.pelletsNeeded = 20
	
	get_tree().change_scene_to_file("res://TItleScreen.tscn")
	pass
