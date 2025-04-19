extends Node2D

const SONG_VOLUME_DB = -18

@onready var _master_bus_index = AudioServer.get_bus_index("Master")

var _tween: Tween
var _scheduled_song_time: float


func _ready() -> void:
	_update_max_fps(200)
	
	$SongScheduled.volume_linear = 0
	$MetronomeScheduled.volume_linear = 0
	
	var scheduled_song_start_time = AudioServer.get_absolute_time() + 1
	print("Scheduled song starting at ", scheduled_song_start_time)
	$SongScheduled.play_scheduled(scheduled_song_start_time)
	$MetronomeScheduled.start(scheduled_song_start_time)
	_scheduled_song_time = scheduled_song_start_time
	
	await get_tree().create_timer(1).timeout
	
	var sys_time = Time.get_ticks_usec() / 1000000.0
	$Song.play()
	$Metronome.start(sys_time)


func _process(_delta: float) -> void:
	var abs_time = AudioServer.get_absolute_time()
	var game_time = Time.get_ticks_usec() / 1000000.0
	
	$Control/VBoxContainer/TimeLabels/TicksLabel.text = "Game Time: %.4f" % game_time
	$Control/VBoxContainer/TimeLabels/AbsTimeLabel.text = "Audio Time: %.4f" % abs_time
	
	if abs_time > _scheduled_song_time:
		_scheduled_song_time += 60 / 130.0 * 32
		$SongScheduled.play_scheduled(_scheduled_song_time)


func _update_max_fps(max_fps: int) -> void:
	Engine.max_fps = max_fps
	ProjectSettings.set("application/run/max_fps", max_fps)
	$Control/VBoxContainer/MaxFps/CenterContainer/HSlider.value = max_fps
	$Control/VBoxContainer/MaxFps/SpinBox.value = max_fps


func _on_max_fps_h_slider_value_changed(value: float) -> void:
	_update_max_fps(int(value))


func _on_max_fps_spin_box_value_changed(value: float) -> void:
	_update_max_fps(int(value))


func _on_use_play_scheduled_check_button_toggled(toggled_on: bool) -> void:
	if _tween:
		_tween.kill()
	
	if toggled_on:
		_tween = create_tween().parallel()
		_tween.tween_property($Song, "volume_linear", 0, 0.2)
		_tween.tween_property($Metronome, "volume_linear", 0, 0.2)
		_tween.tween_property($SongScheduled, "volume_linear", db_to_linear(SONG_VOLUME_DB), 0.2)
		_tween.tween_property($MetronomeScheduled, "volume_linear", 1, 0.2)
	else:
		_tween = create_tween().parallel()
		_tween.tween_property($SongScheduled, "volume_linear", 0, 0.2)
		_tween.tween_property($MetronomeScheduled, "volume_linear", 0, 0.2)
		_tween.tween_property($Song, "volume_linear", db_to_linear(SONG_VOLUME_DB), 0.2)
		_tween.tween_property($Metronome, "volume_linear", 1, 0.2)


func _on_volume_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(_master_bus_index, value)
