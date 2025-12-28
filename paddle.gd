extends CharacterBody2D


## Controls the users speed in pixels per inch
@export var speed: int = 400


func _physics_process(_delta: float) -> void:
	var velocity_y_axis: float = Input.get_axis("paddle_up", "paddle_down")
	velocity.y = velocity_y_axis * speed
	
	move_and_slide()
