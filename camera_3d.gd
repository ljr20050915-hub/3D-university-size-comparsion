extends Camera3D

@export var mouse_sensitivity := 0.005
@export var zoom_ratio := 0.95
@export var move_ratio := 0.5

@export var min_distance := 0.1
@export var max_distance := 1000000.0

var focus := Vector3.ZERO
var distance := 50.0

var yaw := 0.0
var pitch := -0.25

var dragging := false

func _ready():
	update_camera()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance *= zoom_ratio
			distance = clamp(distance, min_distance, max_distance)
			update_camera()

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance /= zoom_ratio
			distance = clamp(distance, min_distance, max_distance)
			update_camera()

	if event is InputEventMouseMotion and dragging:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity

		pitch = clamp(
			pitch,
			deg_to_rad(-89),
			deg_to_rad(89)
		)

		update_camera()

func _process(delta):
	var dir := Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		dir -= global_transform.basis.z

	if Input.is_action_pressed("move_back"):
		dir += global_transform.basis.z

	if Input.is_action_pressed("move_left"):
		dir -= global_transform.basis.x

	if Input.is_action_pressed("move_right"):
		dir += global_transform.basis.x

	if Input.is_action_pressed("move_up"):
		dir += Vector3.UP

	if Input.is_action_pressed("move_down"):
		dir += Vector3.DOWN

	if dir != Vector3.ZERO:
		var speed = max(distance * move_ratio, 0.1)
		focus += dir.normalized() * speed * delta
		update_camera()

func update_camera():
	var offset = Vector3(
		sin(yaw) * cos(pitch),
		sin(pitch),
		cos(yaw) * cos(pitch)
	) * distance

	global_position = focus + offset
	look_at(focus, Vector3.UP)
