extends Node2D

# Circle scene to instance
var Circle = preload("res://Circle.tscn")
var Pellet = preload("res://pellet.tscn")

var pelletCount = 200
var time_start = 0
var time_now = 0

# Generating Circles
func circleGeneration(num_circles):
	for i in range(num_circles):
		Global.circleAte.append(0)
		var circle = Circle.instantiate()
		add_child(circle, true)
		# Randomize initial position
		circle.position = Vector2(
			randi_range(100, get_viewport_rect().size.x-100),
			randi_range(100, get_viewport_rect().size.y-100)
			)

# Generating Pellets
func pelletGeneration(num_pellets):
	for i in range(num_pellets):
		Global.pelletCount+=1
		var pellet = Pellet.instantiate()
		add_child(pellet)
		# Randomize initial position
		pellet.position = Vector2(
			randi_range(25, get_viewport_rect().size.x-25),
			randi_range(25, get_viewport_rect().size.y-25)
			)

func _ready():
	time_start = Time.get_ticks_msec()
	if(Global.generation == 1):
		Global.permaPelletCount = pelletCount
		Global.circleSizes = create_weighted_array(Global.circleCount,remap(Global.sizeBias, 0, 100, 0, 1), 5)
		Global.initialCircleSizes = create_weighted_array(Global.circleCount,remap(Global.sizeBias, 0, 100, 0, 1), 5)
		circleGeneration(Global.circleSizes.size())
		pelletGeneration(pelletCount)
	else:
		pelletGeneration(pelletCount)
		reset()
	
	



func create_weighted_array(length: int, weight: float, intensity: float):
	var result = []
	var min_val = 0.5
	var max_val = 2.0
	
	for i in range(length):
		# Normalized position [0,1] in the array
		var t = float(i) / (length - 1) if length > 1 else 0.5
		
		# Apply weighting
		if weight < 0.5:
			# Skew toward lower values
			t = pow(t, 1.0 + intensity * (0.5 - weight))
		elif weight > 0.5:
			# Skew toward higher values
			t = 1.0 - pow(1.0 - t, 1.0 + intensity * (weight - 0.5))
		
		# Map to our desired range
		var value = min_val + t * (max_val - min_val)
		result.append(value)
	
	return result


func filter_array(numbers: Array, indices: Array):
	var to_keep = []
	# Convert indices to integers and validate them
	for idx in indices:
		var i = int(idx)
		if i >= 0 and i < numbers.size():
			to_keep.append(numbers[i])
	
	numbers.clear()
	numbers.append_array(to_keep)

func average_pairs(input_array: Array):
	var result := []
	var i := 0
	
	while i < input_array.size():
		if i + 1 < input_array.size():
			# Average of current and next element
			var avg = (input_array[i] + input_array[i + 1]) / 2.0
			result.append(avg)
			i += 2
		else:
			# If there's an odd number of elements, add the last one as-is
			result.append(input_array[i])
			i += 1
	
	return result

func are_all_elements_identical(arr: Array) -> bool:
	var first = arr[0]
	for element in arr:
		if element != first:
			return false
	return true



func reset():
	filter_array(Global.circleSizes, Global.survivingCircles)
	Global.circleSizes.shuffle()
	var babies = average_pairs(Global.circleSizes)
	Global.circleSizes.append_array(babies)
	Global.circleSizes.sort()
	
	Global.circleAte.clear()
	circleGeneration(Global.circleSizes.size())
	Global.survivingCircles.clear()


func _process(delta):
	$GenerationLabel.text = "Generation: " + str(int(Global.generation)) +"/"+ str(int(Global.numGenerations))
	time_now = Time.get_ticks_msec()
	var time_scene = time_now-time_start
	if (Global.pelletCount<=0) && (time_scene >= Global.circleCount+100):
		Global.reset = true
		
	if Global.reset:
		# Gets indexes of all circles that ate enough
		for i in range(Global.circleAte.size()):
			if Global.circleAte[i] >= Global.pelletsNeeded:
				Global.survivingCircles.append(i)
		if(Global.survivingCircles.is_empty()):
			get_tree().change_scene_to_file("res://extinction.tscn")
			return
		elif(are_all_elements_identical(Global.circleSizes)):
			get_tree().change_scene_to_file("res://equilibrium.tscn")
		elif(Global.generation >= Global.numGenerations):
			get_tree().change_scene_to_file("res://end_screen.tscn")
			return
		Global.reset = false
		Global.generation+=1
		get_tree().reload_current_scene()
		


func _on_reset_button_pressed() -> void:
	get_tree().change_scene_to_file("res://end_screen.tscn")
