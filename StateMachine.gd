# StateMachine.gd
class_name StateMachine
extends Node

# Drag your starting state (e.g., the 'Idle' node) here in the Inspector.
@export var initial_state: State

var player: CharacterBody2D
var current_state: State
var states: Dictionary = {}

func _ready():
	player = get_parent() # Gets the Player node.
	
	# Store all child states in the dictionary.
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			# Pass a reference of the player and state machine to each state.
			child.player = player
			child.state_machine = self
	
	# Initialize the state machine with the starting state.
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta):
	if current_state:
		current_state.process_frame(delta)

func _physics_process(delta):
	if current_state:
		current_state.process_physics(delta)
		
func _unhandled_input(event: InputEvent):
	if current_state:
		current_state.process_input(event)

# The function that handles changing states.
func transition_to(state_name: String):
	# Check if the requested state exists.
	var new_state = states.get(state_name.to_lower())
	if not new_state:
		return

	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
