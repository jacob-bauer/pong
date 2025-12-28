extends Node
class_name GameWithState


const States = preload("res://states.gd")
const ball_prototype = preload("res://ball.tscn")
const ball_absolute_maximum_speed: int = 63963


@warning_ignore("integer_division")
@export var ball_maximum_speed: int = ball_absolute_maximum_speed / 4
@export var ball_speed_multiplier: float = 1.05


var current_state: States.State
var score: int:
	get:
		return score
	set (value):
		score = value
		$Hud/Score.text = str(value)


func _ready() -> void:
	current_state = States.Waiting.new(self)


func _process(_delta: float) -> void:
	current_state = current_state.update()
