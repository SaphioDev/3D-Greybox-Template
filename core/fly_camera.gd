extends Node3D

@export var base_speed: float = 10.0
@export var sprint_multiplier: float = 2.5
@export var mouse_sensitivity: float = 0.002

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
	# Show mouse cursor on "esc"
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	# Rotate camera on mouse movement / motion
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -PI * 0.49, PI * 0.49)
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			base_speed = clampf(base_speed * 1.5, 1.0, 100.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			base_speed = clampf(base_speed / 1.5, 1.0, 100.0)
			
func _process(delta: float) -> void:
	# Move the camera depending on input
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var vertical: float = Input.get_axis("move_down", "move_up")
	var move_dir: Vector3 = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y) + Vector3.UP * vertical).normalized()
	var speed: float = base_speed * (sprint_multiplier if Input.is_action_pressed("sprint") else 1.0)
	global_position += move_dir * speed * delta
		
