extends Node

@export var planet_scene:PackedScene

const KM_PER_UNIT = 10000.0

var planet_data={
	"Mercury":{"diameter":4879,"texture":"res://mercury.jpg","rotation_speed":0.1},
	"Venus":{"diameter":12104,"texture":"res://venus.jpg","rotation_speed":0.05},
	"Earth":{"diameter":12742,"texture":"res://earth.jpg","rotation_speed":0.5}
}

func _ready():
	var planets_node=get_node("../Planets")
	var distance=0.0
	for planet_name in planet_data:
		var data = planet_data[planet_name]
		var diameter=data["diameter"]
		var texture=data["texture"]
		var rotation_speed=data["rotation_speed"]
		var size=diameter/KM_PER_UNIT
		var planet=planet_scene.instantiate()
		planet.name=planet_name
		planet.scale=Vector3.ONE*size
		planet.position=Vector3(distance,size/2,0)
		planet.rotation_speed=rotation_speed
		var label=planet.get_node("Label3D")
		label.text=planet_name+"\n"+str(diameter)+" km"
		var mesh=planet.get_node("MeshInstance3D")
		var mat=StandardMaterial3D.new()
		mat.albedo_texture=load(texture)
		mesh.material_override=mat
		planets_node.add_child(planet)
		distance+=size*3.0
