extends Node

@export var object_scene:PackedScene

const KM_PER_UNIT = 10000.0

var object_data={
	"Moon":{"type":"moon","roughness":1.0,"specular":0.05,"diameter":3475,"texture":"res://moon.jpg","rotation_speed":0.2},
	"Mercury":{"type":"planet","roughness":0.95,"specular":0.15,"diameter":4879,"texture":"res://mercury.jpg","rotation_speed":0.1},
	"Mars":{"type":"planet","roughness":0.90,"specular":0.10,"diameter":6779,"texture":"res://mars.jpg","rotation_speed":0.5},
	"Venus":{"type":"planet","roughness":0.35,"specular":0.85,"diameter":12104,"texture":"res://venus.jpg","rotation_speed":0.05},
	"Earth":{"type":"planet","roughness":0.55,"specular":0.60,"diameter":12742,"texture":"res://earth.jpg","rotation_speed":0.5},
	"Neptune":{"type":"planet","roughness":0.50,"specular":0.45,"diameter":49244,"texture":"res://neptune.jpg","rotation_speed":0.6},
	"Uranus":{"type":"planet","roughness":0.55,"specular":0.40,"diameter":50724,"texture":"res://uranus.jpg","rotation_speed":0.6},
	"Saturn":{"type":"planet","roughness":0.80,"specular":0.20,"diameter":116464,"texture":"res://saturn.jpg","rotation_speed":0.7},
	"Jupiter":{"type":"planet","roughness":0.75,"specular":0.25,"diameter":139822,"texture":"res://jupiter.jpg","rotation_speed":0.8},
	"Sun":{"type":"star","brightness":7.0,"color":Color(1.0, 0.902, 0.588, 1.0),"diameter":1392700},
	"Sirius A":{"type":"star","brightness":10.0,"color":Color(0.627, 0.914, 0.91),"diameter":2560000},
	"Pollux":{"type":"star","brightness":5.0,"color":Color(1.0, 0.459, 0.243),"diameter":12500000},
	"Arcturus":{"type":"star","brightness":5.0,"color":Color(1.0, 0.208, 0.004),"diameter":35300000},
	"Aldebaran":{"type":"star","brightness":5.0,"color":Color(0.871, 0.286, 0.188),"diameter":61277920},
	"Rigel":{"type":"star","brightness":15.0,"color":Color(0.275, 0.733, 0.902),"diameter":109000000},
	"Pistol Star":{"type":"star","brightness":30.0,"color":Color(0.275, 0.533, 0.902, 1.0),"diameter":425000000},
	"Antares":{"type":"star","brightness":5.0,"color":Color(0.8, 0.212, 0.184, 1.0),"diameter":965000000},
	"VY-Canis-Majoris":{"type":"star","brightness":5.0,"color":Color(0.788, 0.231, 0.22, 1.0),"diameter":1975000000},
	"Stephenson 2-18":{"type":"star","brightness":6.0,"color":Color(0.847, 0.125, 0.004, 1.0),"diameter":2992800000},
	"Sun(Refer to...)":{"type":"star","brightness":7.0,"color":Color(1.0, 0.902, 0.588, 1.0),"diameter":1392700},
}

func _ready():
	var objects_node=get_node("../Objects")
	var distance=0.0
	for object_name in object_data:
		var data = object_data[object_name]
		var diameter=data["diameter"]
		var size=diameter/KM_PER_UNIT
		var mat=StandardMaterial3D.new()
		var object=object_scene.instantiate()
		distance+=1.1*size/2
		object.name=object_name
		object.scale=Vector3.ONE*size
		object.position=Vector3(distance,0,0)
		var label=object.get_node("Label3D")
		label.text=object_name
		if object_name != "Sun(Refer to...)":
			label.text+="\nD="+str(diameter)+" km"
		if object_name == "Sun(Refer to...)":
			label.text+='\n|\n|\n|\n|\n↓'
			label.scale*=1000
			label.position+=Vector3(0,size*4.6,0)
		var mesh=object.get_node("MeshInstance3D")
		if data["type"] in ["moon","planet"]:
			var texture=data["texture"]
			mat.albedo_texture=load(texture)
			var rotation_speed=data["rotation_speed"]
			object.rotation_speed=rotation_speed
			if data.has("roughness"):
				mat.roughness = data["roughness"]
			if data.has("specular"):
				mat.specular = data["specular"]
		elif data["type"] == "star":
			mat.albedo_texture=load("res://star_skin.jpg")
			mat.emission_enabled = true
			mat.emission = data["color"]
			mat.emission_energy_multiplier = data["brightness"]
			var light = OmniLight3D.new()
			light.light_energy = data["brightness"]
			light.light_color = data["color"]
			light.omni_range = size*100
			object.add_child(light)
		mesh.material_override=mat
		objects_node.add_child(object)
		distance+=1.1*size/2
		
