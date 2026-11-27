extends Node3D

@export var player_scene: PackedScene

@onready var spawn_point: Marker3D = $SpawnMain
@onready var fly_camera: Node3D = $FlyCamera

func _ready() -> void:
	if player_scene:
		var player := player_scene.instantiate()
		add_child(player)
		player.global_transform = spawn_point.global_transform
		fly_camera.queue_free()
	else:
		fly_camera.get_node("Camera3D").make_current()

func _unhandled_input(event: InputEvent) -> void:
	# Show mouse cursor on "esc"
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
