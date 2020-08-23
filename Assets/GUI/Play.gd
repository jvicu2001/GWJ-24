extends Button


onready var Level01 = preload("res://Assets/Levels/Level01.tscn")

var root
var root_parent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	root = self.owner
	root_parent = root.get_parent()
	var canvas_fade = root.get_node("ColorRect")
	var animation = canvas_fade.get_node("AnimationPlayer")
	animation.play("fade")
	root.get_node("AudioStreamPlayer").play()


func _on_AnimationPlayer_animation_finished(anim_name):
	var level = Level01.instance()
	root_parent.add_child(level)
	root.queue_free()
	pass # Replace with function body.
