extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
var speed = 200
var current_height = 0  # 0 = низ, 1 = верх
var grid_size = 128
var current_platform = null  # Платформа на которой стоим

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		velocity.y = -speed
	if Input.is_action_pressed("down"):
		velocity.y = +speed
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	if Input.is_action_pressed("right"):
		velocity.x = +speed
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Нажатие Action (пробел)
	if Input.is_action_just_pressed("Action"):
		if not try_change_height():
			push_nearby_box()
	
	# Ограничение движения на верхнем уровне
	if current_height == 1:
		var next_position = position + velocity * _delta
		if not is_high_platform_at_position(next_position):
			velocity = Vector2.ZERO  # Останавливаем если нет платформы
	
	move_and_slide()

func try_change_height() -> bool:
	var direction = get_facing_direction()
	if direction == Vector2.ZERO:
		return false
	
	# Пытаемся подняться
	if current_height == 0:
		var check_position = position + direction * grid_size
		
		# Ищем платформу рядом
		for platform_container in get_tree().get_nodes_in_group("platform_containers"):
			var low_platform = platform_container.get_node("PlatformLow")
			var distance = check_position.distance_to(low_platform.global_position)
			
			if distance < 80:
				print("Поднимаюсь на платформу!")
				current_height = 1
				z_index = 10
				current_platform = platform_container
				
				# ПЕРЕКЛЮЧАЕМ ПЛАТФОРМУ НА ВЫСОКУЮ ВЕРСИЮ
				platform_container.activate_high()
				
				# ТЕЛЕПОРТАЦИЯ НА ПЛАТФОРМУ
				position = low_platform.global_position
				
				modulate = Color(0.8, 0.8, 1.0)
				return true
	
	# Пытаемся спуститься
	elif current_height == 1:
		var check_position = position + direction * grid_size
		
		# Проверяем, что спускаемся в пустоту (не на другую высокую платформу)
		if not is_high_platform_at_position(check_position):
			print("Спускаюсь вниз!")
			current_height = 0
			z_index = 0
			
			# ВОЗВРАЩАЕМ ПЛАТФОРМУ В НИЗКУЮ ВЕРСИЮ
			if current_platform:
				current_platform.activate_low()
				current_platform = null
			
			# Телепортация вниз
			position = check_position
			
			modulate = Color(1, 1, 1, 1)
			return true
	
	return false

func is_high_platform_at_position(pos: Vector2) -> bool:
	# Проверяем наличие ВЫСОКИХ платформ
	for platform_container in get_tree().get_nodes_in_group("platform_containers"):
		var high_platform = platform_container.get_node("PlatformHigh")
		if high_platform.visible:  # Только если высокая версия активна
			var distance = pos.distance_to(high_platform.global_position)
			if distance < 70:
				return true
	return false

func get_facing_direction() -> Vector2:
	if Input.is_action_pressed("up"):
		return Vector2.UP
	elif Input.is_action_pressed("down"):
		return Vector2.DOWN
	elif Input.is_action_pressed("left"):
		return Vector2.LEFT
	elif Input.is_action_pressed("right"):
		return Vector2.RIGHT
	return Vector2.ZERO

func push_nearby_box():
	var direction = get_facing_direction()
	
	if direction == Vector2.ZERO:
		return
	
	for body in get_tree().get_nodes_in_group("boxes"):
		if body.has_method("get_height") and body.get_height() != current_height:
			continue
			
		if position.distance_to(body.position) < 150:
			body.push(direction)
			break
