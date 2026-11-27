class_name InputComponent
extends Node

signal jump_pressed

@export_group("Input Actions")
@export var move_forward: StringName = &"move_forward"
@export var move_backward: StringName = &"move_backward"
@export var move_left: StringName = &"move_left"
@export var move_right: StringName = &"move_right"
@export var jump: StringName = &"jump"
@export var aim: StringName = &"aim"

var move_dir: Vector2 = Vector2.ZERO
var look_delta: Vector2 = Vector2.ZERO
var is_aiming: bool = false

func _process(_delta: float) -> void:
	move_dir = Input.get_vector(move_left, move_right, move_forward, move_backward)
	if Input.is_action_just_pressed(jump):
		jump_pressed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(aim):
		is_aiming = true
	elif event.is_action_released(aim):
		is_aiming = false

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		look_delta += event.relative

func consume_look_delta() -> Vector2:
	var delta := look_delta
	look_delta = Vector2.ZERO
	return delta
