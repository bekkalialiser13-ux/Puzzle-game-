extends StaticBody2D

var height = 0  # Низкий уровень
var high_version = null  # Ссылка на высокую версию

func _ready():
	add_to_group("platforms_low")
