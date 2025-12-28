# Next step is to wait for the user to start the game with some kind of button press, then countdown to launch the ball
#	This should probably happen on Game Overs too
#	This adds states to the game:
#		Waiting to start
#		Playing
#		Game Over

extends Node


const ball_scene = preload("res://ball.tscn")
const ball_absolute_maximum: int = 63963 # This is the maximum speed we've seen before object flies off. It happens at 104 hits


## Multiply the balls speed by this everytime it hits the paddle
@export var ball_speed_multiplier: float = 1.05

## The maximum speed the ball will obtain at any point in the game
@warning_ignore("integer_division")
@export var ball_max_speed = ball_absolute_maximum / 2


var score: int = 0:
	get:
		return score
	set (value):
		score = value
		$Hud/Score.text = str(value)


func _ready() -> void:
	if ball_max_speed > ball_absolute_maximum:
		ball_max_speed = ball_absolute_maximum
		
	score = 0
	start_a_new_ball()


func _on_ball_hit(body: Node, ball_instance: RigidBody2D) -> void:
	if body.name == $Paddle.name:
		ball_instance.multiply_speed_clamped(ball_speed_multiplier, ball_max_speed)
		score += 1


func _on_field_ball_exited(body: Node2D) -> void:
	get_node(str(body.name)).queue_free()
	start_a_new_ball.call_deferred()


# Starts a new ball from starting_position
func start_a_new_ball(starting_position: Vector2=$Field/Center.position) -> void:
	$Hud/Information.visible = false
	score = 0
	
	var realized_ball: Node2D = ball_scene.instantiate()
	
	realized_ball.position = starting_position
	realized_ball.reset_physics_interpolation()
	
	realized_ball.on_ball_hit_something.connect(_on_ball_hit)
	
	add_child(realized_ball)
	realized_ball.begin_movement()
