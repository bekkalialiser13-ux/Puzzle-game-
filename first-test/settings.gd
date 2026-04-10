extends Control

@onready var music_slider = $HSliderMusic
@onready var sound_slider = $HSliderSound
@onready var back_button = $ButtonBack

# Индексы audio bus (0 = Master, 1 = Music, 2 = SFX)
var music_bus_index = 1
var sound_bus_index = 2

func _ready():
	# Загружаем сохранённые настройки
	load_settings()
	
	# Подключаем сигналы
	music_slider.value_changed.connect(_on_music_slider_changed)
	sound_slider.value_changed.connect(_on_sound_slider_changed)
	back_button.pressed.connect(_on_back_button_pressed)

func _on_music_slider_changed(value: float):
	# Конвертируем 0-100 в децибелы (-80 до 0 dB)
	var db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(music_bus_index, db)
	
	# Если 0 - полностью выключаем
	if value == 0:
		AudioServer.set_bus_mute(music_bus_index, true)
	else:
		AudioServer.set_bus_mute(music_bus_index, false)
	
	save_settings()

func _on_sound_slider_changed(value: float):
	var db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(sound_bus_index, db)
	
	if value == 0:
		AudioServer.set_bus_mute(sound_bus_index, true)
	else:
		AudioServer.set_bus_mute(sound_bus_index, false)
	
	save_settings()

func _on_back_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://МЕНЮ/menu.tscn")  # Вернуться в главное меню

func save_settings():
	# Сохраняем настройки в файл
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_slider.value)
	config.set_value("audio", "sound_volume", sound_slider.value)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		# Загружаем сохранённые значения
		music_slider.value = config.get_value("audio", "music_volume", 100)
		sound_slider.value = config.get_value("audio", "sound_volume", 100)
	else:
		# Если файла нет - устанавливаем по умолчанию
		music_slider.value = 100
		sound_slider.value = 100


func _on_button_back_pressed() -> void:
	pass # Replace with function body.
