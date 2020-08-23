extends ColorRect


onready var vignette = preload("res://Assets/Materials/vignette.shader")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.owner.get_parent().intense_music && self.material != null:
		self.set_material(vignette)
	else:
		self.set_material(null)
		
	pass
