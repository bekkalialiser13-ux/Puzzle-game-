extends Node2D

@onready var low_version = $PlatformLow
@onready var high_version = $PlatformHigh

func _ready():
	add_to_group("platform_containers")
	
	# DEBUG: проверяем что у нас есть
	print("=== PLATFORM DEBUG ===")
	print("low_version exists: ", low_version != null)
	print("high_version exists: ", high_version != null)
	
	if low_version:
		print("low_version visible BEFORE: ", low_version.visible)
		low_version.visible = true
		print("low_version visible AFTER: ", low_version.visible)
	
	if high_version:
		print("high_version visible BEFORE: ", high_version.visible)
		high_version.visible = false
		print("high_version visible AFTER: ", high_version.visible)
	
	print("======================")

func activate_high():
	low_version.visible = false
	high_version.visible = true
	print("Платформа стала высокой!")

func activate_low():
	low_version.visible = true
	high_version.visible = false
	print("Платформа стала низкой!")
