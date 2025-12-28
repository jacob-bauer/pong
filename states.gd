@abstract class State:
	var game_data: GameWithState
	
	func _init(game: GameWithState):
		game_data = game
	
	## Every call, this function updates the current state
	## And returns the next state to move to
	@abstract func update() -> State


class Waiting extends State:
	var first_update := true
	
	
	func _init(game: GameWithState):
		super._init(game)
	
	
	func update() -> State:
		if first_update:
			game_data.get_node("Hud/Information").text = "New Game"
			game_data.get_node("Hud/Information").visible = true
			
			game_data.score = 0
			game_data.get_node("Hud/Score").visible = false
			
			first_update = false
		else:
			if Input.is_action_pressed("launch_ball"):
				game_data.get_node("Hud/Information").text = ""
				game_data.get_node("Hud/Information").visible = false
				game_data.get_node("Hud/Score").visible = true
				
				return Playing.new(game_data)
		
		return self


class Playing extends State:
	var first_update := true
	var next_state = self
	
	
	func _init(game: GameWithState):
		super._init(game)


	func update() -> State:
		if first_update:
			first_update = false
			game_data.get_node("Field").ball_exited.connect(_on_field_ball_exited)
			start_a_new_ball()
		
		return next_state
	
	
	func start_a_new_ball(starting_position: Vector2=game_data.get_node("Field/Center").position) -> void:
		var realized_ball: Node2D = game_data.ball_prototype.instantiate()
		realized_ball.position = starting_position
		realized_ball.reset_physics_interpolation()
		
		realized_ball.on_ball_hit_something.connect(
			func(body: Node, ball_instance: RigidBody2D) -> void:
				if body.name == "Paddle":
					ball_instance.multiply_speed_clamped(game_data.ball_speed_multiplier, game_data.ball_maximum_speed)
					game_data.score += 1
		)
		
		game_data.add_child(realized_ball)
		realized_ball.begin_movement()
	
	
	func _on_field_ball_exited(body: Node2D) -> void:
		game_data.get_node(str(body.name)).queue_free()
		next_state = GameOver.new(game_data)


class GameOver extends State:
	var first_update = true
	var next_state = self
	
	
	func _init(game: GameWithState):
		super(game)
	
	
	func update() -> State:
		if first_update:
			game_data.get_node("Hud/Information").text = "Game Over"
			game_data.get_node("Hud/Information").visible = true
			
			# Create a timer, wait for it to go off, and transfer to Waiting
			game_data.get_tree().create_timer(2.5).timeout.connect(
				func() -> void:
					next_state = Waiting.new(game_data)
			)
			
			first_update = false
		
		return next_state
