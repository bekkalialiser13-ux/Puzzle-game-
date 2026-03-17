extends CharacterBody2D

var is_moving = false
var grid_size = 128

func push(direction: Vector2):
	if is_moving:
		return
	
	is_moving = true
	var target_position = position + direction * grid_size
	
	# Пытаемся двинуться
	var collision = move_and_collide(direction * grid_size, true)
	
	if collision:
		# Столкновение - не двигаемся
		is_moving = false
		return
	
	# Анимация движения
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 0.2)
	await tween.finished
	
	is_moving = false
