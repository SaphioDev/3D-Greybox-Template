class_name MovementComponent
extends Node

@export var body: CharacterBody3D
@export var input: InputComponent
@export var camera_rig: Node3D
@export var visuals: Node3D

@export_group("Movement")
@export var move_speed: float = 6.0
@export var acceleration: float = 40.0
@export var friction: float = 35.0
@export var rotation_speed: float = 12.0

@export_group("Jump & Gravity")
@export var jump_height: float = 1.6
@export var time_to_peak: float = 0.4
@export var time_to_descent: float = 0.35

var _jump_velocity: float
var _jump_gravity: float
var _fall_gravity: float
var _wants_jump: bool

func _ready() -> void:
	_calculate_jump_physics()
	if input:
		input.jump_pressed.connect(_on_jump_pressed)
		
func _calculate_jump_physics() -> void:
	_jump_velocity = (2.0 * jump_height) / time_to_peak
	_jump_gravity = (-2.0 * jump_height) / (time_to_peak * time_to_peak)
	_fall_gravity = (-2.0 * jump_height) / (time_to_descent * time_to_descent)
	
func _on_jump_pressed() -> void:
	if body and body.is_on_floor():
		_wants_jump = true
		
func _physics_process(delta: float) -> void:
	if not body or not input:
		return
	
	# Apply asymmetric gravity (snappier fall than rise)
	if not body.is_on_floor():
		var grav := _jump_gravity if body.velocity.y > 0.0 else _fall_gravity
		body.velocity.y += grav * delta
		
	# Execute queued jump
	if _wants_jump:
		body.velocity.y = _jump_velocity
		_wants_jump = false
		
	# Convert 2D input to camera-relative 3D direction
	var cam_basis := camera_rig.global_transform.basis if camera_rig else body.global_transform.basis
	var forward := -cam_basis.z
	var right := cam_basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()
	
	var wish_dir := (right * input.move_dir.x + forward * -input.move_dir.y).normalized()
	
	# Horizontal acceleration / friction
	var horizontal_vel := Vector3(body.velocity.x, 0.0, body.velocity.z)
	if wish_dir != Vector3.ZERO:
		horizontal_vel = horizontal_vel.move_toward(wish_dir * move_speed, acceleration * delta)
		if visuals:
			var target_angel := atan2(-wish_dir.x, -wish_dir.z)
			visuals.rotation.y = lerp_angle(visuals.rotation.y, target_angel, rotation_speed * delta)
	else:
		horizontal_vel = horizontal_vel.move_toward(Vector3.ZERO, friction * delta)
		
	body.velocity.x = horizontal_vel.x
	body.velocity.z = horizontal_vel.z
	body.move_and_slide()
	
