extends Node2D

var drag_active: bool
var click_delta: float

func load_map(path: String):
	$Map/Sprite2D.texture = load(path)

func get_point() -> Vector2:
	return $Map/Point.position

func clear_point():
	$Map/Point.visible = false
	$Map/Point.position = Vector2(0, 0)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$Map.scale /= 1.2
			return
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Map.scale *= 1.2
			return
		drag_active = event.pressed
		if event.pressed:
			click_delta = 0
			return
		if click_delta < 1:
			$Map/Point.global_position = event.position
			$Map/Point.visible = true
	elif event is InputEventMouseMotion:
		if not drag_active:
			return
		click_delta += event.relative.x + event.relative.y
		$Map.position += event.relative
	
