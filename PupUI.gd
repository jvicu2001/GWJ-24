extends TextureRect

onready var inactive_pup_icon = preload("res://Assets/GUI/Pup2_inactive_con.png")
onready var active_pup_icon = preload("res://Assets/GUI/Pup2_icon.png")

var done = false
var ready = false

var pup


# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = inactive_pup_icon


func setup(pup_node):
	pup = pup_node
	ready = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ready && !done:
		if !pup.imprisoned:
			self.texture = active_pup_icon
			done = true
