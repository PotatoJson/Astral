# State.gd
class_name State
extends Node

# References that will be set by the StateMachine.
var player: CharacterBody2D
var state_machine: Node

# These are "virtual" functions. 
func enter():
	pass

func exit():
	pass
	
func process_input(event: InputEvent):
	pass

func process_frame(delta: float):
	pass

func process_physics(delta: float):
	pass
