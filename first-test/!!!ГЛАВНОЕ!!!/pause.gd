extends Control

@onready var button_continue = $continuebtn
@onready var button_menu = $menubtn

signal continue_pressed
signal menu_pressed

func _ready():
	# Подключаем кнопки
	button_continue.pressed.connect(_on_continue_pressed)
	button_menu.pressed.connect(_on_menu_pressed)
	
	# Скрываем по умолчанию
	hide()

func _on_continue_pressed():
	continue_pressed.emit()

func _on_menu_pressed():
	menu_pressed.emit()

func show_pause():
	show()
	get_tree().paused = true  # ОСТАНАВЛИВАЕМ ИГРУ!

func hide_pause():
	hide()
	get_tree().paused = false  # ПРОДОЛЖАЕМ ИГРУ!
