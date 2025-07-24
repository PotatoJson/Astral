# MoveState.gd
extends State

@export var dash_state: State
@export var idle_state: State
@export var jab_state: State
@export var hook_state: State



func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	# Handle movement logic.
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if move_input == Vector2.ZERO:
		return idle_state
		
	if Input.is_action_just_pressed("dash"):
		return dash_state
		
	if Input.is_action_just_pressed("jab"):
		return jab_state
		
	if Input.is_action_just_pressed("hook"):
		return hook_state
		
	parent.velocity = move_input * move_speed
	parent.move_and_slide()
	return null
