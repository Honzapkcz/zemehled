extends Node2D

var drag_active: bool
var click_delta: float
var offset: Vector2

func _ready():
	$Map/Point2.visible = false

func load_map(path: String):
	$Map/Sprite2D.texture = load(path)

func get_point() -> Vector2:
	return $Map/Point.position

func clear_point():
	$Map/Point.visible = false
	$Map/Point.position = Vector2(0, 0)
	$Map/Point2.visible = false

func show_location(location: Vector2):
	$Map/Point2.position = location
	$Map/Point2.visible = true
	offset = location
	$Map.position = offset * $Map.scale + get_viewport_rect().size / 2

func center_map():
	offset = -$Map/Sprite2D.get_rect().size / 2
	$Map.position = offset * $Map.scale + get_viewport_rect().size / 2

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$Map.scale /= 1.2
			$Map/Point.scale *= 1.2
			$Map/Point2.scale *= 1.2
			$Map.position = offset * $Map.scale + get_viewport_rect().size / 2
			return
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Map.scale *= 1.2
			$Map/Point.scale /= 1.2
			$Map/Point2.scale /= 1.2
			$Map.position = offset * $Map.scale + get_viewport_rect().size / 2
			return
		drag_active = event.pressed
		if event.pressed:
			click_delta = 0
			return
		if click_delta < 0.1 and click_delta > -0.1:
			$Map/Point.global_position = event.position
			$Map/Point.visible = true
	elif event is InputEventMouseMotion:
		if not drag_active:
			return
		click_delta += event.relative.x + event.relative.y
		offset += event.relative / $Map.scale
		$Map.position = offset * $Map.scale + get_viewport_rect().size / 2
	
