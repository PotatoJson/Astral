# DashState.gd
extends State

@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2

var dash_vector: Vector2

func enter():
	# Dash in the direction of current input, or forward if no input.
	var move_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if move_input != Vector2.ZERO:
		dash_vector = move_input.normalized()
	else:
		# Fallback: dash in the direction the player is facing.
		# This requires tracking direction, so for now we'll just dash down.
		dash_vector = Vector2.DOWN 
	
	# Start the dash timer.
	# The 'await' keyword pauses the 'enter' function until the timer is done.
	await get_tree().create_timer(dash_duration).timeout
	
	# After the timer finishes, transition back to Idle.
	state_machine.transition_to("Idle")

func process_physics(delta: float):
	# During the dash, movement is non-negotiable.
	player.velocity = dash_vector * dash_speed
	player.move_and_slide()
