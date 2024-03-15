extends Control

var popup_open: bool
var question: int = -1
var time_left: int
var playing: bool = true

func _ready():
	$Status/Menu.get_popup().index_pressed.connect(on_menu_selected)
	$Image.position.x = get_viewport_rect().size.x
	$Margin/Map/View/Map.load_map(Global.game.map)
	mainloop()

func on_menu_selected(index: int):
	match index:
		0: #Skip
			time_left = 0
		1: #Settings
			pass
		2: #Leave
			playing = false

func mainloop():
	while playing:
		question += 1
		if question >= Global.game.rounds:
			break
		$Image/Image/Border/Texture.texture = load(Global.game.images[question])
		get_tree().create_tween().tween_property($Image, "position:x", 649, 1.0)
		time_left = Global.answer_time
		$Status/Round.text = "%02d/%02d" % [question + 1, Global.game.rounds]
		while time_left >= 0:
			$Status/Time.text = "%02d:%02d" % [int(time_left / 60), time_left % 60]
			await get_tree().create_timer(1.0).timeout
			time_left -= 1
			if not playing:
				break
		await get_tree().create_tween().tween_property($Image, "position:x", get_viewport_rect().size.x + 10, 1.0).finished
		# (649, 0) <- (1152, 0)
	end()

func end():
	popup_open = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Status, "position:x", -120, 1.0)
	tween.parallel().tween_property($Image, "position:x", get_viewport_rect().size.x, 1.0).set_delay(0.5)
	tween.parallel().tween_property($Margin, "scale", Vector2(0.0, 0.0), 1.0).set_delay(1.0)
	tween.parallel().tween_property($Border, "modulate:a", 0.0, 1.0).set_delay(1.5)
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
