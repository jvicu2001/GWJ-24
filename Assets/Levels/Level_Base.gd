extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ray_length = 1000
onready var camera = $CameraControl/Pivot/Camera
var mouse
onready var Player = load("res://Assets/Actors/Player.tscn")
onready var Dog = load("res://Assets/Actors/Dog.tscn")
onready var Pup = load("res://Assets/Actors/Pup.tscn")
var player
var dog
var pups = []
onready var Selection_cursor_scene = preload("res://Assets/Test/Selection_cursor.tscn")
var selection_cursor
var valid_move_pos = false
var current_player

signal setup_ready


# Called when the node enters the scene tree for the first time.
func _ready():
	player = Player.instance()
	self.add_child(player)
	
	dog = Dog.instance()		# Replace with dog once finished
	self.add_child(dog)
	
	for PupSpawner in $PupSpawners.get_children():
		var pup = Pup.instance()
		self.add_child(pup, true)
		pup.dog_parent = dog
		pup.navigation = $Navigation
		pup.global_transform.origin = PupSpawner.global_transform.origin
		pups.append(pup)
	
	player.global_transform.origin = $PlayerSpawnPoint.global_transform.origin
	dog.global_transform.origin = $DogSpawnPoint.global_transform.origin
	
	current_player = player
	current_player.active = true
	emit_signal("setup_ready")
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("player_switch"):
		current_player.active = false
		if current_player == player:		# Replace with a List
			current_player = dog
		else:
			current_player = player
		current_player.active = true
	#if event.is_action_pressed("move_click"):
	#	get_relative_mouse_collider(mouse)
	if Input.is_action_just_pressed("debug_reset"):
		self.get_tree().reload_current_scene()
	pass


#func align_with_y(xform, new_y):
#	xform.basis.y = new_y
#	xform.basis.x = -xform.basis.z.cross(new_y)
#	xform.basis = xform.basis.orthonormalized()
#	return xform

func select_cursor_handler(collision):
	if !collision.empty():
		if !is_instance_valid(selection_cursor):
			selection_cursor = Selection_cursor_scene.instance()
			self.add_child(selection_cursor)
#		var current_grid_element = collision.collider.world_to_map(collision.position)
		if collision.collider.name != "FloorGridMap":
			selection_cursor.get_node("AnimationPlayer").play("invalid_select")
			valid_move_pos = false
		else:
			selection_cursor.get_node("AnimationPlayer").play("valid_select")
			valid_move_pos = true
		#var grid_element_center = collision.collider.map_to_world(current_grid_element.x, current_grid_element.y, current_grid_element.z)
		#selection_cursor.global_transform.origin = grid_element_center	#This would snap the cursor to the center of the tile

		selection_cursor.global_transform.origin = collision.position
		
		if Input.is_action_just_pressed("move_click") && valid_move_pos:
			var path = $Navigation.get_simple_path(dog.global_transform.origin, collision.position)
			#var nav_path = path
			var path_paint = $ImmediateGeometry
			path_paint.clear()
			path_paint.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
			for vect in path:
				path_paint.set_normal(Vector3(0, 1, 0))
				path_paint.set_uv(Vector2(1, 1))
				path_paint.add_vertex(vect)
			path_paint.end()
		#selection_mesh.set_surface_material(0, wireframe)
		#selection.global_transform.rotated(Vector3.UP, collision.normal.angle_to(Vector3.UP))
	elif is_instance_valid(selection_cursor):
		selection_cursor.queue_free()

func get_relative_mouse_collider(mouse_pos):
	var space_state = get_world().direct_space_state
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	return space_state.intersect_ray(from, to, [], 6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_player == player:
		mouse = get_viewport().get_mouse_position()
		var collision = get_relative_mouse_collider(mouse)
		select_cursor_handler(collision)
	pass
