extends Panel


var player
var ready = false

onready var active_material = preload("res://Assets/GUI/ListSelected.material")


func setup(player_node):
	player = player_node
	$Label.text = player.name


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if ready:
		if player.active:
			self.material = active_material
		else:
			self.material = null
