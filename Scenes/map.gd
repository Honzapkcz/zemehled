extends Node2D

func load_map(path: String):
	$Sprite2D.texture = load(path)

func get_point() -> Vector2:
	return Vector2.ZERO
