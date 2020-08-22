extends Spatial


var open = false

var tooltip_text = "Open"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interaction(_source):
	if open:
		$AnimationPlayer.play_backwards("default")
		tooltip_text = "Open"
	else:
		$AnimationPlayer.play("default")
		tooltip_text = "Close"
	open = !open
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
