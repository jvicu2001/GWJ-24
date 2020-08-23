extends Spatial

onready var spawns = self.get_children()

onready var Enemy = load("res://Assets/Actors/Enemy.tscn")

onready var nav_points = self.get_parent().get_node("EnemyNavPoints").get_children()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LevelContainer_setup_ready():
	for spawnpoint in spawns:
		var enemy = Enemy.instance()
		self.get_parent().add_child(enemy)
		enemy.setup(nav_points)
		enemy.global_transform.origin = spawnpoint.global_transform.origin
