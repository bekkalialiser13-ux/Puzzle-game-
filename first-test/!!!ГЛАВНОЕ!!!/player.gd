extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var stepsound1 = $StepSound1
@onready var stepsound2 = $StepSound2

var speed = 200
var last_direction = Vector2.DOWN
var is_step_1 = true  # Для чередования звуков
var step_timer = 0.0  # Таймер шагов
var step_interval = 0.2  # Интервал между шагами

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		input_direction.y = -1
	if Input.is_action_pressed("down"):
		input_direction.y = 1
	if Input.is_action_pressed("left"):
		input_direction.x = -1
	if Input.is_action_pressed("right"):
		input_direction.x = 1
	
	if input_direction != Vector2.ZERO:
		last_direction = input_direction.normalized()
		velocity = last_direction * speed
		
		# Обновляем таймер шагов когда идём
		step_timer += _delta
		if step_timer >= step_interval:
			play_step_sound()
			step_timer = 0.0
	else:
		# Сбрасываем таймер когда стоим
		step_timer = 0.0
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	update_animation(input_direction)
	move_and_slide()

func play_step_sound():
	if is_step_1:
		stepsound1.play()
	else:
		stepsound2.play()
	
	# Переключаем на другой звук
	is_step_1 = !is_step_1

func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		# Стоим - показываем idle в последнем направлении
		if abs(last_direction.x) > abs(last_direction.y):
			# Горизонтальное направление
			if last_direction.x > 0:
				anim.play("Right")
			else:
				anim.play("Left")
		else:
			# Вертикальное направление
			if last_direction.y > 0:
				anim.play("Front")
			else:
				anim.play("Back")
	else:
		# Двигаемся - показываем walk
		if abs(direction.x) > abs(direction.y):
			# Движение горизонтально
			if direction.x > 0:
				anim.play("Right")
			else:
				anim.play("Left")
		else:
			# Движение вертикально
			if direction.y > 0:
				anim.play("FrontWalk")
			else:
				anim.play("Back")
