# JabState.gd
extends State

# This state assumes you have an AnimatedSprite2D node in your scene
# named "AnimatedSprite2D" (or you can change the node path).
# It also assumes you have an animation named "jab".
@onready var animation_player = %AnimatedSprite2D

# Assign these states in the Inspector so the JabState
# knows where to go when it's finished.
@export var idle_state: State
@export var move_state: State

# This variable holds the state to transition to.
# It remains 'null' (no transition) until the jab animation is complete.
var next_state: State = null

# The enter() function runs once when the state is entered.
# It should run quickly and not use 'await'.
func enter() -> void:
	super()
	# Reset the next state on each new jab.
	next_state = null

	# 1. Stop the player's movement immediately.
	parent.velocity = Vector2.ZERO

	# 2. Play the jab animation.
	animation_player.play("jab")

	# 3. Connect the animation_finished signal to our function.
	#    This does NOT pause the code. The state will continue running
	#    its process_physics function until the signal is received.
	animation_player.animation_finished.connect(_on_jab_finished)


# process_physics() runs every physics frame. Since the player is stationary
# during a jab, we only need to check if it's time to transition.
func process_physics(_delta: float) -> State:
	# The state machine will transition as soon as 'next_state' is set.
	return next_state


# This function is called ONLY when the "jab" animation finishes.
func _on_jab_finished() -> void:
	# It's good practice to disconnect a one-shot signal.
	animation_player.animation_finished.disconnect(_on_jab_finished)

	# Now we decide which state to enter next based on player input.
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_input != Vector2.ZERO:
		next_state = move_state
	else:
		next_state = idle_state


# The exit() function is a good place for cleanup.
func exit() -> void:
	# If the state is exited for any reason before the animation finishes
	# (e.g., player takes damage), we ensure the signal is disconnected
	# to prevent it from firing later and causing bugs.
	if animation_player.is_connected("animation_finished", _on_jab_finished):
		animation_player.animation_finished.disconnect(_on_jab_finished)
