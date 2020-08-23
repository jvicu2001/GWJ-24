extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var Test_Level = preload("res://Assets/Levels/Test_Level.tscn")
#onready var Level01 = preload("res://Assets/Levels/Level01.tscn")
onready var GUI = preload("res://GUI.tscn")
onready var Menu = preload("res://Assets/GUI/MainMenu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	pass # Replace with function body.

func initialize():
#	var curr_level = Test_Level.instance()
#	var curr_level = Level01.instance()
#	var menu = Menu.instance()
	var menu = Menu.instance()
	self.add_child(menu)
#	var gui = GUI.instance()
#	self.add_child(gui)
#	self.add_child(curr_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
