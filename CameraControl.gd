extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ready = false

var inputs = {
	"camera_pan": 0.0,
	"camera_angle": 0		# Maybe start at 45° (1)?
}

onready var camera = $Pivot/Camera
onready var camera_pivot = $Pivot
# var camera_mode = true	# True = Analog, False = Digital
var camera_angles = [0.0, PI/4, PI/2, 3*(PI/4), PI, 5*(PI/4), 3*(PI/2), 7*(PI/4)]
#var camera_current_angle = 0.0

var player
var smooth_pan = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(_e):	
	#if e.is_action("camera_pan_analog_right") || e.is_action("camera_pan_analog_left"):
#		camera_mode = true
#		inputs.camera_pan = Input.get_action_strength("camera_pan_analog_right")\
#	 	- Input.get_action_strength("camera_pan_analog_left")
	
#	if e.is_action("camera_pan_left") || e.is_action("camera_pan_right"):
#		camera_mode = false
	inputs.camera_angle += int(Input.is_action_just_pressed("camera_pan_right"))\
	- int(Input.is_action_just_pressed("camera_pan_left"))


func camera_movement():
	camera_pivot.global_transform.origin =\
	lerp(camera_pivot.global_transform.origin, player.global_transform.origin,\
	0.1)

func camera_analog_rotation(pan):
	if pan != 0.0:
		smooth_pan = lerp_angle(smooth_pan, pan * 0.1, 0.005)
	else:
		smooth_pan = lerp_angle(smooth_pan, pan * 0.1, 0.3)
	camera_pivot.rotate_y(smooth_pan)

func camera_digital_rotation():
	smooth_pan = lerp_angle(smooth_pan, camera_angles[inputs.camera_angle % 8], 0.3)
	camera_pivot.rotation.y = smooth_pan
	pass

func setup():
	player = get_parent().current_player
	ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ready:
		if player != get_parent().current_player:
			player = get_parent().current_player
		camera_movement()
#		if camera_mode:		# Vestigial analog camera code
#			camera_analog_rotation(inputs.camera_pan)
#		else:
		camera_digital_rotation()


func _on_LevelContainer_setup_ready():
	setup()
