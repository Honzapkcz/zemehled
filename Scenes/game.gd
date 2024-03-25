extends Control

var popup_open: bool
var question: int = -1
var time_left: int
var playing: bool = true
var position_delta: PackedVector2Array
var submit_clicked: bool

func _ready():
	$Status/Menu.get_popup().index_pressed.connect(on_menu_selected)
	$Image.position.x = get_viewport_rect().size.x
	$Margin/Map/View/Map.load_map(Global.game.map)
	Global.settings_changed.connect(on_settings_changed)
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
			$Margin/Map/View/Map.center_map()
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
		$Image/Image/Border/Texture.texture = load(Global.game.images[question])
		get_tree().create_tween().tween_property($Image, "position:x", 649, 1.0)
		time_left = Global.answer_time
		$Status/Round.text = "%02d/%02d" % [question + 1, Global.game.rounds]
		while time_left >= 0:
			submit_clicked = false
			$Status/Time.text = "%02d:%02d" % [int(time_left / 60), time_left % 60]
			await get_tree().create_timer(1.0).timeout
			time_left -= 1
			if not playing or submit_clicked:
				break
		position_delta.append(Global.game.positions[question] - $Margin/Map/View/Map.get_point())
		$Margin/Map/View/Map.show_location(Global.game.positions[question])
		$DropEffect.play()
		if playing:
			await $Submit/Button.pressed
		$Margin/Map/View/Map.clear_point()
		$MoveEffect.play()
		await get_tree().create_tween().tween_property($Image, "position:x", get_viewport_rect().size.x + 10, 1.0).finished
		# (649, 0) <- (1152, 0)
	end()

func end():
	popup_open = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Status, "position:x", -120, 1.0)
	tween.parallel().tween_property($Image, "position:x", get_viewport_rect().size.x, 1.0).set_delay(0.25)
	tween.parallel().tween_property($Margin, "scale", Vector2(0.0, 0.0), 1.0).set_delay(0.5)
	tween.parallel().tween_property($Border, "modulate:a", 0.0, 1.0).set_delay(0.75)
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_button_pressed():
	pass # Replace with function body.
