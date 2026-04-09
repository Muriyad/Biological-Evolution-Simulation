extends RigidBody2D

class_name circle

# Speed of the circle
var impulse = 200

# Minimum and maximum size for the circle
@export var min_scale: float = 0.5
@export var max_scale: float = 2

var pellets_eaten = 0

var circleIndex = 0

func _ready():
	# Set initial counter value
	$Counter.text = str(pellets_eaten)
	
	# Set initial velocity
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	apply_impulse(impulse * direction)
	
		# Store Circle Info
	if(name.replace("circle", "")).is_valid_int():
		circleIndex = int(name.replace("@RigidBody2D@", ""))-1
	else:
		circleIndex = 0
	# Set the size of the circle
	var Scale = Global.circleSizes[circleIndex]
	$CollisionBox.scale *= Scale
	$Sprite2D.scale *= Scale
	set_mass(pow(Scale,2))

	
func _on_area_entered(area):
	pellets_eaten+=1
	$Counter.text = str(pellets_eaten)
	
	# Update circle info
	Global.circleAte[circleIndex] = pellets_eaten
