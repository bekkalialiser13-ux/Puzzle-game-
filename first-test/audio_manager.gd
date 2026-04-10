extends Node

func _ready():
	load_settings()

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		var music_volume = config.get_value("audio", "music_volume", 100)
		var sound_volume = config.get_value("audio", "sound_volume", 100)
		
		# Применяем настройки
		var music_db = linear_to_db(music_volume / 100.0)
		var sound_db = linear_to_db(sound_volume / 100.0)
		
		AudioServer.set_bus_volume_db(1, music_db)  # Music bus
		AudioServer.set_bus_volume_db(2, sound_db)  # SFX bus
		
		# Mute если 0
		AudioServer.set_bus_mute(1, music_volume == 0)
		AudioServer.set_bus_mute(2, sound_volume == 0)
