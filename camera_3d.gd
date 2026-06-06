extends Camera3D

@export var base_speed:=0.5
@export var mouse_sensitivity :=0.005
@export var zoom_speed :=2.0

var dragging:= false
var yaw :=0.0
var pitch :=0.0

func _input(event):
	#检测鼠标事件
	if event is InputEventMouseButton:
		#鼠标左键拖动视角
		if event.button_index==MOUSE_BUTTON_LEFT:
			dragging=event.pressed
		#滚轮缩放
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov-=zoom_speed
		if event.button_index==MOUSE_BUTTON_WHEEL_DOWN:
			fov+=zoom_speed
		fov=clamp(fov,5.0,90.0)
	#鼠标移动
	if event is InputEventMouseMotion and dragging:
		yaw-=event.relative.x*mouse_sensitivity
		pitch-=event.relative.y*mouse_sensitivity
		pitch=clamp(pitch,deg_to_rad(-89),deg_to_rad(89))
		rotation=Vector3(pitch,yaw,0)

func _process(delta):
	var dir=Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		dir-=transform.basis.z
	if Input.is_action_pressed("move_back"):
		dir+=transform.basis.z
	if Input.is_action_pressed("move_left"):
		dir-=transform.basis.x
	if Input.is_action_pressed("move_right"):
		dir+=transform.basis.x
	if Input.is_action_pressed("move_up"):
		dir+=Vector3.UP
	if Input.is_action_pressed("move_down"):
		dir+=Vector3.DOWN
	if dir!=Vector3.ZERO:
		#根据距离自动调整速度
		var speed=position.length()*base_speed
		speed=clamp(speed,5.0,5000.0)
		position+=(dir.normalized()*speed*delta)
		
		
