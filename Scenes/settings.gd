extends Control

var is_open: bool

func _ready():
	$AudioStreamPlayer.volume_db = Global.sfx_volume
	Global.settings_changed.connect(on_settings_changed)
	$Settings.visible = false

func open_menu():
	if not is_open:
		is_open = true
	$Settings.position.x = get_viewport_rect().size.x
	$Settings.visible = true
	$AudioStreamPlayer.play()
	get_tree().create_tween().tween_property($Settings, "position:x", 176, 1.0)

func close_menu():
	$AudioStreamPlayer.play()
	await get_tree().create_tween().tween_property($Settings, "position:x", get_viewport_rect().size.x, 1.0).finished
	if is_open:
		return
	$Settings.visible = false

func on_settings_changed():
	$AudioStreamPlayer.volume_db = Global.sfx_volume

func _on_effect_volume_value_changed(value: int):
	Global.sfx_volume = value
	Global.settings_changed.emit()

func _on_music_volume_value_changed(value: int):
	Global.music_volume = value
	Global.settings_changed.emit()
