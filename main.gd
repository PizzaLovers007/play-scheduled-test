extends Node2D

const metronome_resource = preload("res://Perc_MetronomeQuartz_hi.wav")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.register_stream_as_sample(metronome_resource)
	
	#var curr_time = AudioServer.get_absolute_time()
	var curr_time = Time.get_ticks_usec() / 1000000.0
	print("starting at ", curr_time+1)
	#$Song.play_scheduled(curr_time + 1)
	$Song.play()
	$Metronome.start(curr_time + 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("Current absolute time: ", AudioServer.get_absolute_time())
	pass
