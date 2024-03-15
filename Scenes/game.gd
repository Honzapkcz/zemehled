extends Control

var popup_open: bool
var question: int

func _ready():
	$Status/Menu.get_popup().index_pressed.connect(on_menu_selected)

func on_menu_selected(index: int):
	match index:
		0: #Skip
			next_question()
		1: #Settings
			pass
		2: #Leave
			end()

func next_question():
	pass
	# (649, 0) <- (1152, 0)

func end():
	popup_open = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Status, "position:x", -120, 1.0)
	tween.parallel().tween_property($Image, "position:x", get_viewport_rect().size.x, 1.0).set_delay(0.5)
	tween.parallel().tween_property($Margin, "scale", Vector2(0.0, 0.0), 1.0).set_delay(1.0)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
