extends Control

class ZemeGame:
	var game_name: String
	var description: String
	var rounds: int
	var difficulty: int
	var game_image: String
	var map_image: String
	var images: PackedStringArray
	var positions: PackedVector2Array
	
	func _init(path := ""):
		if path.is_empty():
			return
		self.load(path)
	
	func load(path):
		pass
