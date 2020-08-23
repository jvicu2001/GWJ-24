extends Panel


var dog
var pups
var ready = false

onready var active_material = preload("res://Assets/GUI/ListSelected.material")

onready var Pup_item = load("res://Assets/GUI/PupItem.tscn")


func setup(player_node):
	dog = player_node
	$Label.text = dog.name


func add_pup(pup):
	var pupitem = Pup_item.instance()
	$HSplitContainer.add_child(pupitem)
	pupitem.setup(pup)


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if ready:
		if dog.active:
			self.material = active_material
		else:
			self.material = null
