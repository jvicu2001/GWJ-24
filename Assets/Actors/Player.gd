extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var inputs = {
	"raw_mov": Vector2(),
	"mov": Vector2(),
	"mov_strength": 0,
	"running": false
}
export var walking_speed = 5
export var running_speed = 8
var speed
var velocity = Vector3()
onready var model_rotation = self.get_rotation()
var angle = 0.0
var camera_angle = 0.0
export var gravity = - 20
var rot_mov = Vector2()

var interactive_object = null

export var active = false

onready var camera_pivot = get_parent().get_node("CameraControl/Pivot")
onready var camera = camera_pivot.get_node("Camera")

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
	if Input.is_action_just_pressed("player_use") && interactive_object != null && active:
		interactive_object.interaction(self)
#	inputs.mov = inputs.raw_mov.normalized() * inputs.mov_strength
	

func move(delta):
	if sign(camera_pivot.global_transform.basis.z.x) == -1:
		camera_angle = camera_pivot.global_transform.basis.z.angle_to(Vector3(0,0,1))
	else:
		camera_angle = 2*PI - camera_pivot.global_transform.basis.z.angle_to(Vector3(0,0,1))
	rot_mov.x = (inputs.mov.x * cos(camera_angle)) + (inputs.mov.y * -sin(camera_angle))
	rot_mov.y = (inputs.mov.x * sin(camera_angle)) + (inputs.mov.y * cos(camera_angle))
	
	if inputs.running:
		speed = running_speed
	else:
		speed = walking_speed
	
	velocity.x = lerp(velocity.x, rot_mov.x * speed, 0.5)
	velocity.z = lerp(velocity.z, rot_mov.y * speed, 0.5)
	if inputs.mov != Vector2(0,0):			# Rotate if moving
		rotate_model()
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, 0.802851) # 0.802851 = 46°
	velocity.y += gravity * delta

func rotate_model():
	angle = atan2(velocity.x, velocity.z)
	model_rotation = self.get_rotation()
	model_rotation.y = lerp_angle(model_rotation.y, angle, 0.2)
	self.set_rotation(model_rotation)


func tooltip_handler():
	if interactive_object != null && active:
		$HintContainer.visible = true
		var tooltip_pos = camera.unproject_position(interactive_object.global_transform.origin\
		+ Vector3.UP) - $HintContainer.rect_size/2
		$HintContainer.set_position(tooltip_pos)
		$HintContainer/HBoxContainer/Hint.text = interactive_object.tooltip_text
	else:
		$HintContainer.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	#$MeshInstance.rotate_y(-model_angle)
	if active:
		move(delta)
		tooltip_handler()

func _on_Interaction_Area_body_entered(body):
	if body != self && body.is_in_group("can_use") && interactive_object == null:
		interactive_object = body


func _on_Interaction_Area_body_exited(body):
	if body == interactive_object:
		interactive_object = null
