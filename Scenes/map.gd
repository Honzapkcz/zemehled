extends Node2D

var drag_active: bool

func load_map(path: String):
	$Sprite2D.texture = load(path)

func get_point() -> Vector2:
	return Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$Sprite2D.scale /= 1.2
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Sprite2D.scale *= 1.2
		drag_active = event.pressed
	elif event is InputEventMouseMotion:
		if not drag_active:
			return
		$Sprite2D.position += event.relative
	
