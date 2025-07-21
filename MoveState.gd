# MoveState.gd
extends State

@export var move_speed: float = 300.0

func enter():
	# Play the move/run animation
	player.get_node("AnimatedSprite2D").play("run")

func process_physics(delta: float):
	# Check for transitions first.
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return

	# Handle movement logic.
	var move_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if move_input == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return
		
	player.velocity = move_input * move_speed
	player.move_and_slide()
