# The scene tree needs to be modified to be a staticbody2d so that collision is exposed when
# instancing the scene

extends Node2D


## Emitted when a body exits the playing field
signal ball_exited(body: Node2D)


func _on_out_of_bounds_body_exited(body: Node2D) -> void:
	ball_exited.emit(body)
