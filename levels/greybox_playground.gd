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
