extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
var speed = 200

func _physics_process(delta: float) -> void:
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
	
	# Толкание ящика при нажатии пробела
	if Input.is_action_just_pressed("ui_accept"):
		push_nearby_box()
	
	move_and_slide()

func push_nearby_box():
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		direction = Vector2.RIGHT
	
	if direction == Vector2.ZERO:
		return
	
	for body in get_tree().get_nodes_in_group("boxes"):
		if position.distance_to(body.position) < 150:
			body.push(direction)
			break
