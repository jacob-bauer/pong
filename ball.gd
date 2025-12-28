extends RigidBody2D


signal on_ball_hit_something(body_hit: Node, ball_instance: RigidBody2D)


## Controls speed in pixels per inch
@export var speed: int = 400

## Controls how many degrees from horizontal the balls initial vector can be
@export var starting_verticality: int = 60


func _on_body_entered(body: Node) -> void:
	on_ball_hit_something.emit(body, self)


func begin_movement() -> void:
	apply_impulse(get_random_direction() * speed)


func get_random_direction() -> Vector2:
	var max_angle: float = deg_to_rad(starting_verticality)
	var angle: float = randf_range(-max_angle, max_angle)
	
	var direction := Vector2.from_angle(angle)
	
	# If the angle is below |90| degrees it will only ever point towards positive x
	# But we are really just after an angle deviation from the x axis in any x direction
	if randf_range(-1, 1) > 0:
		direction = -direction
	
	return direction


func multiply_speed_clamped(multiplier: float, max_speed: int) -> void:
	var new_velocity: Vector2 = linear_velocity * multiplier
	
	if new_velocity.length() < max_speed:
		linear_velocity = new_velocity
