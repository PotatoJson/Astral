extends CharacterBody2D

@export var speed = 300.0

func _physics_process(delta):
	# Get input from the arrow keys or WASD using the pre-defined input actions.
	# This returns a direction vector, like (1, 0) for right or (-1, -1) for up-left.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Set the velocity.
	velocity = direction * speed

	# This is the built-in function that moves the body and handles collisions.
	move_and_slide()
