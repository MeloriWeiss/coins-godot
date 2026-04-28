extends CanvasLayer

signal use_move_vector
var move_vector = Vector2(0,0)
var joystick_active = false


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $TouchScreenButton.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
		if event is InputEventScreenTouch:
			if event.pressed == false:
				joystick_active = false


func _physics_process(_delta: float):
	if joystick_active:
		emit_signal("use_move_vector", move_vector)
 
func calculate_move_vector(event_position):
	var texture_center = $TouchScreenButton.position + Vector2(75,75)
	return (event_position - texture_center).normalized()
