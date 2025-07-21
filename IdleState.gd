# IdleState.gd
extends State

func enter():
	# When entering the idle state, stop all movement.
	player.velocity = Vector2.ZERO
	# play Idle animation here
	player.get_node("AnimatedSprite2D").play("idle")

func process_frame(_delta):
	# Check for transitions out of Idle.
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return # exit the function after a transition.

	var move_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if move_input != Vector2.ZERO:
		state_machine.transition_to("Move")
