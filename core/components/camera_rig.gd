class_name CameraRig
extends Node3D

@export var input: InputComponent

@export_group("Camera Settings")
@export var mouse_sensitivity: float = 0.003
@export var min_pitch_deg: float = -70.0
@export var max_pitch_deg: float = 45.0
@export var camera_height: Vector3 = Vector3(0, 0.9, 0)
@export var spring_arm_length: float = 6.0

@onready var spring_arm: SpringArm3D = $SpringArm3D

func _ready() -> void:
	spring_arm.add_excluded_object(get_parent() as CollisionObject3D)
	position = camera_height
	spring_arm.spring_length = spring_arm_length
		
func _process(_delta: float) -> void:
	if not input:
		return
	
	var look := input.consume_look_delta()
	if look != Vector2.ZERO:
		rotate_y(-look.x * mouse_sensitivity)
		spring_arm.rotate_x(-look.y * mouse_sensitivity)
		spring_arm.rotation.x = clamp(
				spring_arm.rotation.x,
				deg_to_rad(min_pitch_deg),
				deg_to_rad(max_pitch_deg)
		)
