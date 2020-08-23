extends Spatial


var open = false
var Pup = load("res://Assets/Actors/Pup.tscn")
var pup

var level

var ready = false

var tooltip_text = "Open"


# Called when the node enters the scene tree for the first time.
func _ready():
	level = self.get_parent()
	pass


func setup():
	pup = Pup.instance()
	level.add_child(pup, true)
	pup.dog_parent = level.get_node("Dog")
	#pup.navigation = $Navigation
	pup.global_transform.origin = $PupSpawner.global_transform.origin
	level.pups.append(pup)
	
	level.startup_step = 3
	ready = true

func interaction(_source):
	$AudioStreamPlayer3D.set_pitch_scale(rand_range(0.85, 1.15))
	$AudioStreamPlayer3D.play()
	if open:
		$AnimationPlayer.play_backwards("default")
		tooltip_text = "Open"
	else:
		$AnimationPlayer.play("default")
		if pup.imprisoned:
			pup.imprisoned = false
			self.get_parent().dogs_freed += 1
		#self.remove_from_group("can_use")
		tooltip_text = "Close"
	open = !open
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level.startup_step >= 2 && !ready:
		setup()
	pass
