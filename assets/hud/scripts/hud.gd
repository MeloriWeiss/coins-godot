extends CanvasLayer

signal start_game
var start_text = "Собери монетки"

func _ready() -> void:
	$Message.text = start_text


func _process(value) -> void:
	pass


func update_score(value):
	$MarginContainer/Time.text = str(value)

func update_timer(value):
	$MarginContainer/Score.text = str(value)

func show_message(text):
	$Message.text = text
	$Message.show()
	$Timer.start()

#событие по истечении подключённого таймера
func _on_timer_timeout() -> void:
	$Message.hide()

#клик по кнопке старта
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Message.hide()
	start_game.emit()

#окончание игры
func show_game_over():
	show_message("Игра окончена")
	#ждём окончания таймаута
	await $Timer.timeout
	
	#разрешаем начать игру заново
	$StartButton.show()
	$Message.text = start_text
	$Message.show()
