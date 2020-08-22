extends KinematicBody

var inputs = {
	"raw_mov": Vector2(),
	"mov": Vector2(),
	"mov_strength": 0,
	"running": false
}
export var walking_speed = 5
export var running_speed = 10
var speed
var velocity = Vector3()
onready var model_rotation = self.get_rotation()
var angle = 0.0
var camera_angle = 0.0
export var gravity = - 20
var rot_mov = Vector2()

var pups = []

export var active = false

var tooltip_text = "Pet"

onready var camera = get_parent().get_node("CameraControl/Pivot")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(_e):
	inputs.raw_mov.x = Input.get_action_strength("player_left")\
	 - Input.get_action_strength("player_right")
	inputs.raw_mov.y = Input.get_action_strength("player_forward")\
	- Input.get_action_strength("player_backwards")
	inputs.mov_strength = max(abs(inputs.raw_mov.x), abs(inputs.raw_mov.y))
	inputs.mov = inputs.raw_mov.normalized()
	inputs.running = Input.is_action_pressed("player_run")
#	inputs.mov = inputs.raw_mov.normalized() * inputs.mov_strength
	

func move(delta):
	if sign(camera.global_transform.basis.z.x) == -1:
		camera_angle = camera.global_transform.basis.z.angle_to(Vector3(0,0,1))
	else:
		camera_angle = 2*PI - camera.global_transform.basis.z.angle_to(Vector3(0,0,1))
	rot_mov.x = (inputs.mov.x * cos(camera_angle)) + (inputs.mov.y * -sin(camera_angle))
	rot_mov.y = (inputs.mov.x * sin(camera_angle)) + (inputs.mov.y * cos(camera_angle))
	
	if inputs.running:
		speed = running_speed
	else:
		speed = walking_speed
		
	velocity.x = lerp(velocity.x, rot_mov.x * speed, 0.5)
	velocity.z = lerp(velocity.z, rot_mov.y * speed, 0.5)
	if inputs.mov != Vector2(0,0):			# Rotate if moving
		$AnimationPlayer.play("walking")
		rotate_model()
	else:
		$AnimationPlayer.play("idle")
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, 0.802851) # 0.802851 = 46°
	velocity.y += gravity * delta

func rotate_model():
	angle = atan2(velocity.x, velocity.z)
	model_rotation = self.get_rotation()
	model_rotation.y = lerp_angle(model_rotation.y, angle, 0.2)
	self.set_rotation(model_rotation)


func interaction(_source):
	$Particles.set_emitting(true)
	$Particles.set_emitting(false)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	#$MeshInstance.rotate_y(-model_angle)
	if active:
		move(delta)
