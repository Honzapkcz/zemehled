extends Node
class_name GlobalScene

signal settings_changed

var sfx_volume: int
var music_volume: int
var answer_time: int
var game: ZemeGame

class ZemeGame:
	var type: String
	var name: String
	var description: String
	var rounds: int
	var difficulty: int
	var thumbnail: String
	var map: String
	var images: PackedStringArray
	var positions: PackedVector2Array
	
	func _to_string():
		var out: String = "ZemeGame{"
		var d: String
		for i in self.get_property_list():
			if i.type in [TYPE_NIL, TYPE_OBJECT]:
				continue
			d = "'" if i.type == TYPE_STRING else ""
			out += "%s: %s%s%s, " % [i.name, d, self[i.name], d]
		return out + "}"
		
	
	func load(data: Dictionary):
		for i in self.get_property_list():
			print(i)
			if not data.has(i.name):
				continue
			if i.name == "positions" and data.has("positions"):
				for j in data.positions:
					positions.append(Vector2(j[0], j[1]))
				continue
			elif i.name == "images" and data.has("images"):
				images.append_array(PackedStringArray(data.images))
			self[i.name] = data[i.name]


func load_all() -> Array[ZemeGame]:
	var games: Array[ZemeGame] = []
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
