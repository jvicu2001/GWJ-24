extends Spatial


var open = false
var Dog = load("res://Assets/Actors/Dog.tscn")
var dog

var level

var tooltip_text = "Open"

var ready = false


# Called when the node enters the scene tree for the first time.
func _ready():
	level = self.get_parent()
	pass


func setup():
	dog = Dog.instance()
	level.add_child(dog, true)
	#dog.navigation = $Navigation
	dog.global_transform.origin = $DogSpawner.global_transform.origin
	level.players.append(dog)
	
	level.startup_step = 2
	ready = true

func interaction(_source):
	$AudioStreamPlayer3D.set_pitch_scale(rand_range(0.85, 1.15))
	$AudioStreamPlayer3D.play()
	if open:
		$AnimationPlayer.play_backwards("default")
		tooltip_text = "Open"
	else:
		$AnimationPlayer.play("default")
		if dog.imprisoned:
			dog.imprisoned = false
			self.get_parent().dogs_freed += 1
		tooltip_text = "Close"
	open = !open
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level.startup_step == 1 && !ready:
		setup()
	pass
