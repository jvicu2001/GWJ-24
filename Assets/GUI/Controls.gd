extends Button

onready var tex = preload("res://Assets/GUI/Controls.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Controls_pressed():
	owner.get_node("Controls").set_visible(true)
	owner.get_node("Controls").set_texture(tex)
	pass # Replace with function body.
