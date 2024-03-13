extends Control


@onready var person: Node3D = $D3/SubViewport/Person
@onready var planet: Node3D = $D3/SubViewport/CSGSphere3D
@onready var label: Label = $Menu/Layout/Label
@onready var rot_speed: float = 1.5
var rot: Vector3
var lbl: int
var pop_open: bool

func _ready():
	pass


func _physics_process(delta):
	#planet.rotate_y(0.005)
	if Engine.get_physics_frames() % 10 != 0:
		return
	rot += Vector3(randf_range(0.0, rot_speed), randf_range(0.0, rot_speed), randf_range(0.0, rot_speed))
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(person, "rotation", rot, 0.16)
	tween.parallel().tween_property(planet, "rotation:y", 0.05, 0.16).as_relative()
	
	if Engine.get_physics_frames() % 20 != 0:
		return
	lbl += 1
	if lbl > 7:
		lbl = 0
	label.text = "zeměhleď".substr(0, lbl) + "zeměhleď"[lbl].to_upper() + "zeměhleď".substr(lbl + 1)


func _on_play_pressed():
	if pop_open:
		return
	pop_open = true
	get_tree().create_tween().tween_property($Play, "position:y", 140, 1.0)
	$Effect.play()


func _on_settings_pressed():
	if pop_open:
		return
	pop_open = true
	$Settings.position.x = get_viewport_rect().size.x
	$Settings.visible = true
	get_tree().create_tween().tween_property($Settings, "position:x", 176, 1.0)
	$Effect.play()


func _on_exit_pressed():
	get_tree().quit()


func _on_settings_close_pressed():
	pop_open = false
	$Effect.play()
	await get_tree().create_tween().tween_property($Settings, "position:x", get_viewport_rect().size.x, 1.0).finished
	if pop_open:
		return
	$Settings.visible = false


func _on_play_close_pressed():
	pop_open = false
	get_tree().create_tween().tween_property($Play, "position:y", 648, 1.0)
	$Effect.play()
