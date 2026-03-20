extends Node2D

var height = 1  # Высокий уровень

func _ready():
	add_to_group("platforms_high")
	visible = false  # Скрыта по умолчанию
