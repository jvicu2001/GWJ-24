extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Test_Level = preload("res://Assets/Levels/Test_Level.tscn")
onready var GUI = preload("res://GUI.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	pass # Replace with function body.

func initialize():
	var curr_level = Test_Level.instance()
	var gui = GUI.instance()
	self.add_child(gui)
	self.add_child(curr_level)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
