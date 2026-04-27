extends Area2D

var screensize = Vector2.ZERO

func _ready() -> void:
	$Timer.start(randf_range(1, 3))

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
