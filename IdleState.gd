# IdleState.gd
extends State

@export var dash_state: State
@export var move_state: State
@export var jab_state: State
@export var hook_state: State


func enter() -> void:
	super()
	# When entering the idle state, stop all movement.
	parent.velocity = Vector2.ZERO

func process_frame(_delta):
	if Input.is_action_just_pressed("jab"):
		return jab_state
		
	if Input.is_action_just_pressed("hook"):
		return hook_state
	
	# Check for transitions out of Idle.
	if Input.is_action_just_pressed("dash"):
		return dash_state # exit the function after a transition.

	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_input != Vector2.ZERO:
		return move_state
