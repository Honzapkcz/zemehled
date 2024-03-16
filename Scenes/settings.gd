extends Control

signal settigs_changed

var is_open: bool

func open_menu():
	if not is_open:
		is_open = true
	$Settings.position.x = get_viewport_rect().size.x
	$Settings.visible = true
	get_tree().create_tween().tween_property($Settings, "position:x", 176, 1.0)

func close_menu():
	await get_tree().create_tween().tween_property($Settings, "position:x", get_viewport_rect().size.x, 1.0).finished
	if is_open:
		return
	$Settings.visible = false

func _on_effect_volume_value_changed(value: int):
	Global.sfx_volume = value
	settigs_changed.emit()

func _on_music_volume_value_changed(value: int):
	Global.music_volume = value
	settigs_changed.emit()
