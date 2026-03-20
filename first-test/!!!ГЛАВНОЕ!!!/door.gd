extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		await get_tree().create_timer(0.3).timeout  # Задержка 0.3 секунды
		go_to_menu()

func go_to_menu():
	get_tree().change_scene_to_file("res://МЕНЮ/menu.tscn")
