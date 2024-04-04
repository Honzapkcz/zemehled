extends Control

var popup_open: bool
var question: int = -1
var time_left: int
var playing: bool = true
var position_delta: PackedInt32Array
var submit_clicked: bool
var order: PackedInt32Array

func _ready():
	$Status/Menu.get_popup().index_pressed.connect(on_menu_selected)
	$Margin/SView/View/Map.load_map(Global.game.map)
	$Image.custom_minimum_size = get_viewport_rect().size / 2
	Global.settings_changed.connect(on_settings_changed)
	if Global.game.type == "classic":
		for i in range(Global.game.rounds):
			order.append(i)
	elif Global.game.type == "classic-random":
		var ord: Array
		for i in range(Global.game.rounds):
			ord.append(i)
		ord.shuffle()
		order.append_array(PackedInt32Array(ord))
	on_settings_changed()
	mainloop()

func on_settings_changed():
	$ThemePlayer.volume_db = Global.music_volume
	$MoveEffect.volume_db = Global.sfx_volume
	$StartEffect.volume_db = Global.sfx_volume
	$DropEffect.volume_db = Global.sfx_volume

func on_menu_selected(index: int):
	match index:
		0: # Skip
			time_left = 0
		1: # Center
			$Margin/SView/View/Map.center_map()
		2: # Settings
			$Settings.open_menu()
		3: # Leave
			playing = false

func mainloop():
	await get_tree().create_timer(4.0).timeout
	$MoveEffect.play()
	$ThemePlayer.play()
	while playing:
		question += 1
		if question >= Global.game.rounds:
			break
		$Image/Image/Border/Texture.texture = load(Global.game.images[order[question]])
		get_tree().create_tween().tween_property($Image, "position:x", get_viewport_rect().size.x / 2, 1.0)
		time_left = Global.answer_time
		$Status/Round.text = "%02d/%02d" % [question + 1, Global.game.rounds]
		while time_left >= 0:
			submit_clicked = false
			$Status/Time.text = "%02d:%02d" % [int(time_left / 60), time_left % 60]
			await get_tree().create_timer(1.0).timeout
			time_left -= 1
			if not playing or submit_clicked:
				break
		position_delta.append(round(sqrt((Global.game.positions[order[question]].round().x
		- $Margin/SView/View/Map.get_point().round().x)**2 + (Global.game.positions[order[question]].round().y
		- $Margin/SView/View/Map.get_point().round().y)**2)))
		$Margin/SView/View/Map.show_location(Global.game.positions[order[question]])
		$DropEffect.play()
		$Submit/VBox/Label.text = "Rozdíl: " + str(position_delta[-1])
		$Margin/SView/View/Map.can_point = false
		if playing:
			await $Submit/VBox/Button.pressed
		$Margin/SView/View/Map.can_point = true
		$Margin/SView/View/Map.clear_point()
		$Submit/VBox/Label.text = ""
		$MoveEffect.play()
		await get_tree().create_tween().tween_property($Image, "position:x", get_viewport_rect().size.x + 10, 1.0).finished
		# (649, 0) <- (1152, 0)
	end()

func end():
	popup_open = true
	$Ending.visible = true
	$MoveEffect.play()
	var x: int
	for i in position_delta:
		if i > x:
			x = i
	$Ending/Borders/Layout/Max.text = str(x)
	for i in position_delta:
		x += i
	$Ending/Borders/Layout/Sum.text = str(x)
	$Ending/Borders/Layout/Average.text = str(x / position_delta.size())
	get_tree().create_tween().tween_property($Ending, "position:y", get_viewport_rect().size.y - 550, 1.0)
	await $Ending/Header/Close.pressed
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Ending, "position:y", get_viewport_rect().size.y, 1.0)
	tween.parallel().tween_property($Status, "position:x", -120, 1.0)
	tween.parallel().tween_property($Image, "position:x", get_viewport_rect().size.x, 1.0).set_delay(0.25)
	tween.parallel().tween_property($Margin, "scale", Vector2(0.0, 0.0), 1.0).set_delay(0.5)
	tween.parallel().tween_property($Border, "modulate:a", 0.0, 1.0).set_delay(0.75)
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_button_pressed():
	submit_clicked = true
