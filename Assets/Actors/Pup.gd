extends KinematicBody


var ready = false
var imprisoned = true
var navigation
var dog_parent

var rand_dog_parent_center = Vector2()
var hiding_spot

var movement = Vector2()
var velocity = Vector3()
export var gravity = - 20
export var speed = 6
var angle = 0.0
var min_distance = 0

var path


# Called when the node enters the scene tree for the first time.
func _ready():	
	randomize()
	min_distance = rand_range(2, 3)
	rand_dog_parent_center.x = rand_range(-1,1)
	rand_dog_parent_center.y = rand_range(-1,1)
	pass # Replace with function body.

func move(delta):
	velocity.x = lerp(velocity.x, movement.x * speed, 0.05)
	velocity.z = lerp(velocity.z, movement.y * speed, 0.05)
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, 0.802851)
	velocity.y += gravity * delta
	pass

#func parent_follow():
#	if self.global_transform.origin.distance_to(dog_parent.global_transform.origin) > min_distance:
#		path = navigation.get_simple_path(self.global_transform.origin,
#		dog_parent.global_transform.origin)
		# Here should be code to follow the path, but this may end not being used

func parent_follow_simple(_delta):
	if self.global_transform.origin.distance_to(dog_parent.global_transform.origin) > min_distance:
		movement.x = dog_parent.global_transform.origin.x - (self.global_transform.origin.x + rand_dog_parent_center.x)
		movement.y = dog_parent.global_transform.origin.z - (self.global_transform.origin.z + rand_dog_parent_center.y)
		movement = movement.normalized()
		angle = -Vector2(0,1).angle_to(movement)
		self.rotation.y = lerp_angle(self.rotation.y, angle, 0.2)
#		movement *= speed
	elif dog_parent.covering:
		movement.x = dog_parent.get_node("PupCoveringPos").global_transform.origin.x - self.global_transform.origin.x
		movement.y = dog_parent.get_node("PupCoveringPos").global_transform.origin.z - self.global_transform.origin.z
		movement = movement.normalized()
		angle = -Vector2(0,1).angle_to(movement)
		self.rotation.y = lerp_angle(self.rotation.y, angle, 0.2)
	else:
		movement *= 0

		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	if !imprisoned:
#		parent_follow()
		parent_follow_simple(delta)
	move(delta)
