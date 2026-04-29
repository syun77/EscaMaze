extends Node2D

var pos = Vector2()

func _process(delta: float) -> void:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		dir.x = -1
	if Input.is_action_pressed("ui_right"):
		dir.x = 1
	
