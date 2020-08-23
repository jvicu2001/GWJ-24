extends Control

var ready = false
var pups_ready = false
export var pup_amount = 3

onready var Level_Scene = load("res://Assets/Levels/Level01.tscn")

var player
var dog

onready var level = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Fade/AnimationPlayer.play("fade_in")


func setup():
	player = level.players[0]
	dog = level.players[1]
	
	$GridContainer/PlayerInfoBox.setup(player)
	$GridContainer/DogInfoBox.setup(dog)
	
	ready = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level.startup_step >= 2 && !ready:
		setup()
	if level.pups.size() == pup_amount && !pups_ready:
		for pup in level.pups:
			$GridContainer/DogInfoBox.add_pup(pup)
		pups_ready = true
	if player.caught or dog.caught:
		$Fade/AnimationPlayer.play("fade_out")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		var level = Level_Scene.instance()
		self.get_parent().get_parent().add_child(level)
		self.get_parent().queue_free()
	if anim_name == "fade_white":
		$CenterContainer.set_visible(true)
