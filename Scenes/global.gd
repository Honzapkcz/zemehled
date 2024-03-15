extends Node
class_name GlobalScene

class ZemeGame:
	var name: String
	var description: String
	var rounds: int
	var difficulty: int
	var thumbnail: String
	var map: String
	var images: PackedStringArray
	var positions: PackedVector2Array
	
	func load(data: Dictionary):
		if not data.has("type") or data["type"] != "classic":
			return
		for i in self.get_property_list():
			if not data.has(i):
				return
			self[i.name] = data[i]
			

func load_all() -> Array[ZemeGame]:
	var games: Array[ZemeGame]
	for i in DirAccess.get_directories_at("res://Games"):
		var d: = DirAccess.open("res://Games/" + i)
		if not d.file_exists("game.json"):
			continue
		var file: FileAccess = FileAccess.open("res://Games/" + i + "/game.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			data = [data]
		if not typeof(data) == TYPE_ARRAY:
			continue
		for j in data:
			var z: = ZemeGame.new()
			z.load(j)
			games.append(z)
	return games
