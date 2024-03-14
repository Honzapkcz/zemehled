extends Node

class ZemeGame:
	var name: String
	var description: String
	var rounds: int
	var difficulty: int
	var image: String
	var map_image: String
	var images: PackedStringArray
	var positions: PackedVector2Array
	
	func load(data):
		pass
		

func load_all() -> Array[ZemeGame]:
	var games: Array[ZemeGame]
	for i in DirAccess.get_directories_at("res://Games"):
		var d: = DirAccess.open("res://Games/" + i)
		if not d.file_exists("game.json"):
			continue
		var file: FileAccess = FileAccess.open("res://Games/" + i, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			data = [data]
		if not typeof(data) == TYPE_ARRAY:
			continue
		for j in data:
			var z: = ZemeGame.new()
			z.load(data)
			games.append(z)
	return games
