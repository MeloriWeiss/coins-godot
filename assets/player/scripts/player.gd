extends Area2D

#кастомные сигналы
signal pickup
signal hurt

#переменная, которая видна в инспекторе
@export var speed = 350

#скорость по векторам
var velocity = Vector2.ZERO

#размер экрана
var screensize = Vector2(480, 720)

func _ready() -> void:
	#старт скрипта
	start()

func _process(delta: float) -> void:
	#обработка каждого кадра
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	
	#ограничение движения персонажа по экрану
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	#установка анимаций
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
		
	#поворот спрайта
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func start() -> void:
	#подготовка сцены
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
func die() -> void:
	#завершение игры, анимация смерти
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Coins"):
		#столкновение с монетками
		area.pickup()
		pickup.emit()
	if area.is_in_group("Obstacles"):
		#столкновение с препятствиями
		hurt.emit()
		die()
