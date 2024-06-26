extends Control


@onready var person: Node3D = $D3/SubViewport/Person
@onready var planet: Node3D = $D3/SubViewport/CSGSphere3D
@onready var label: Label = $Menu/Layout/Label
@onready var list: ItemList = $Play/Borders/GridContainer/List
@onready var minutes: SpinBox = $Play/Borders/GridContainer/Layout/Minutes
@onready var seconds: SpinBox = $Play/Borders/GridContainer/Layout/Seconds 
@onready var description: Label = $Play/Borders/GridContainer/Content/Description
@onready var image: TextureRect = $Play/Borders/GridContainer/Content/Image
var rot_speed: float = 1.5
var rot: Vector3
var lbl: int
var pop_open: bool
var gamez: Array[GlobalScene.ZemeGame]

func _ready():
	Input.set_custom_mouse_cursor(preload("res://Assets/Cursors/beam.png"), Input.CURSOR_IBEAM, Vector2(10, 10))
	Global.settings_changed.connect(on_settings_changed)
	$ThemePlayer.volume_db = Global.music_volume
	$Effect.volume_db = Global.sfx_volume
	gamez = Global.load_all()
	for i in gamez:
		list.add_item(i.name)
	print(gamez)
	
func _physics_process(delta):
	#planet.rotate_y(0.005)
	if Engine.get_physics_frames() % 10 != 0:
		return
	rot += Vector3(randf_range(0.0, rot_speed), randf_range(0.0, rot_speed), randf_range(0.0, rot_speed))
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(person, "rotation", rot, delta * 9)
	tween.parallel().tween_property(planet, "rotation:y", 0.05, delta * 9).as_relative()
	
	if Engine.get_physics_frames() % 20 != 0:
		return
	lbl += 1
	if lbl > 7:
		lbl = 0
	label.text = "zeměhleď".substr(0, lbl) + "zeměhleď"[lbl].to_upper() + "zeměhleď".substr(lbl + 1)

func on_settings_changed():
	$ThemePlayer.volume_db = Global.music_volume
	$Effect.volume_db = Global.sfx_volume

func _on_play_pressed():
	pop_open = true
	$Play.visible = true
	get_tree().create_tween().tween_property($Play, "position:y", get_viewport_rect().size.y - 550, 1.0)
	$Effect.play()


func _on_settings_pressed():
	pop_open = true
	$Settings.open_menu()
	$Effect.play()


func _on_exit_pressed():
	get_tree().quit()


func _on_play_close_pressed():
	pop_open = false
	$Effect.play()
	await get_tree().create_tween().tween_property($Play, "position:y", get_viewport_rect().size.y, 1.0).finished
	$Play.visible = false


func _on_play_game_pressed():
	if list.get_selected_items().is_empty():
		return
	elif gamez[list.get_selected_items()[0]].rounds < 1:
		return
	Global.game = gamez[list.get_selected_items()[0]]
	Global.answer_time = minutes.value * 60 + seconds.value
	$Effect.play()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Play, "position:y", get_viewport_rect().size.y, 1.0)
	tween.parallel().tween_property($Menu, "scale", Vector2(0.0, 0.0), 1.0).set_delay(0.5)
	tween.parallel().tween_property($TextureRect, "modulate:a", 0.0, 1.0).set_delay(0.5)
	tween.parallel().tween_property(person, "scale", Vector3(0.0, 0.0, 0.0), 1.0).set_delay(1.0)
	tween.parallel().tween_property(planet, "scale", Vector3(0.0, 0.0, 0.0), 1.0).set_delay(1.0)
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	#TODO: push volumes


func _on_list_item_selected(index: int):
	description.text = gamez[index].description
	image.texture = load(gamez[index].thumbnail)
