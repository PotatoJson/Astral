# DashState.gd
extends State

@onready var animation_player = %AnimatedSprite2D

@export var dash_speed: float = 500.0
@export var dash_duration: float = 0.25

@export var idle_state: State
@export var move_state: State

# This variable holds the state to transition to.
# It remains 'null' (no transition) until the dash is complete.
var next_state: State = null
var dash_vector: Vector2

# The enter() function should only be used for initial setup.
# It should run quickly and not be paused with 'await'.
func enter() -> void:
	super()
	# Reset the next state on each new dash.
	next_state = null

	# 1. Determine the dash direction.
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_input != Vector2.ZERO:
		dash_vector = move_input.normalized()
	else:
		# A better fallback is to get the player's last facing direction.
		# For now, we'll keep your original fallback.
		dash_vector = Vector2.DOWN

	# 2. Set the velocity once at the start.
	parent.velocity = dash_vector * dash_speed

	# 3. Create a timer and connect its 'timeout' signal to our function.
	#    This DOES NOT pause the code.
	get_tree().create_timer(dash_duration).timeout.connect(_on_dash_timeout)


# process_physics() now runs every physics frame during the dash.
func process_physics(_delta: float) -> State:
	# We just need to move the parent. Velocity is already set.
	parent.move_and_slide()

	# The state machine will transition as soon as 'next_state' is set.
	return next_state


# This function is called ONLY when the timer finishes.
func _on_dash_timeout() -> void:
	parent.velocity = Vector2.ZERO

	# Wait for the dash animation to finish for a smoother feel.
	# Because this is a separate function, awaiting here won't block physics processing.
	await animation_player.animation_finished

	# Now we decide which state to enter next based on player input.
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_input != Vector2.ZERO:
		next_state = move_state
	else:
		next_state = idle_state
