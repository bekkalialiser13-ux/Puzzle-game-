extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
var speed = 200

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

	move_and_slide()
