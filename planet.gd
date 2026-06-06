extends Node3D

@export var rotation_speed:=0.0
@onready var mesh = $MeshInstance3D

func _process(delta):
	mesh.rotate_y(rotation_speed * delta)
