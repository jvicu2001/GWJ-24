extends KinematicBody

var following_player = false
var following_body = null
var player_last_pos = Vector3()

export var search_timeout = 5.0

var walking = false
export var new_path_timeout = 3.0

var timeout = 5.0

var speed = 5.0

var moving = false

onready var navmesh = get_parent().get_node("Navigation")
var nav_points

var route
var endpoint
var next_pos

var velocity = Vector3()
var angle

var ready = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(navpoints):
	nav_points = navpoints
	ready = true
	pass

func _physics_process(delta):
	if !moving:
		timeout -= delta
		if timeout <= 0.0:
			if following_player:
				self.get_parent().player_followed -= 1
				following_player = false
			get_next_route()
			timeout = new_path_timeout
	else:
		if route.size() == 0 || self.global_transform.origin.distance_to(route[0]) < 1:
			route.remove(0)
			if route.size() == 0:
				moving = false
				return
				
		if following_player && following_body != null:
			velocity = (following_body.global_transform.origin - self.global_transform.origin).normalized() * speed
		else:
			velocity = (route[0] - self.global_transform.origin).normalized() * speed
		angle = -Vector2(0,1).angle_to(Vector2(velocity.x, velocity.z).normalized())
		self.rotation.y = lerp_angle(self.rotation.y, angle, 0.15)
		self.move_and_slide(velocity, Vector3.UP)
	pass

func get_next_route():
	var options = []
	for point in nav_points:
		var distance = self.global_transform.origin.distance_to(point.global_transform.origin)
		if (distance > 3.0) && (distance < 45.0):
			options.append(point)
	route = navmesh.get_simple_path(self.global_transform.origin,\
	options[randi() % (options.size())].global_transform.origin)
	moving = true

func search():
	route = navmesh.get_simple_path(self.global_transform.origin, player_last_pos)


func _on_Interaction_Area_body_entered(body):
	if following_body == null && body.is_in_group("player"):
		following_body = body
		following_player = true
		self.get_parent().player_followed += 1


func _on_Interaction_Area_body_exited(body):
	if body == following_body:
		following_body = null
		player_last_pos = body.global_transform.origin
		var timeout = search_timeout
		search()


func _on_CollisionArea_body_entered(body):
	if body.is_in_group("player"):
		body.caught = true
