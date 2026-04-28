extends Node2D

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var obstacle_scene : PackedScene

@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready() -> void:
	#определяем размеры экрана
	screensize = get_viewport().get_visible_rect().size
	#у узла Player меняем свойство screensize
	$Player.screensize = screensize
	#скрываем узел игрока до нужного нам момента
	$Player.hide()
	$Mobile_Joystick.hide()


func _process(delta: float) -> void:
	#проверяем, закончен ли уровень
	if playing and get_tree().get_nodes_in_group("Coins").size() == 0:
		new_level()
		
	if $Mobile_Joystick.joystick_active == false:
		$Player/AnimatedSprite2D.animation = "idle"


func new_game():
	#подготавливаем сцены при старте
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$Mobile_Joystick.show()
	$GameTimer.start()
	spawn_coins()
	spawn_obstacles()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func spawn_coins():
	$LevelSound.play()
	#увеличиваем количество монеток с каждым уровнем
	for i in level + 4:
		#инстанцируем сцену с монетками
		var c = coin_scene.instantiate()
		add_child(c)
		#устанавливаем сцене размер окна
		c.screensize = screensize
		#задаём случайную позицию
		c.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))

func spawn_obstacles():
	for i in 2:
		var o = obstacle_scene.instantiate()
		add_child(o)
		o.screensize = screensize
		
		if i == 0:
			o.position = Vector2(randi_range(100, screensize.x/2-50),randi_range(100, screensize.y-100))
		else:
			o.position = Vector2(randi_range(screensize.x/2+50,screensize.x-100 ),randi_range(100, screensize.y-100))

func new_level():
	level += 1
	time_left += 5
	spawn_coins()
	$PowerupTimer.wait_time = randf_range(4, 9)
	$PowerupTimer.start()


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_timer(time_left)
	
	if time_left <= 0:
		game_over()

#окончание игры
func game_over():
	playing = false
	$GameTimer.stop()
	#удаляем все монетки
	get_tree().call_group("Coins", "queue_free")
	get_tree().call_group("Obstacles", "queue_free")
	#показываем интерфейс окончания игры
	$HUD.show_game_over()
	$Mobile_Joystick.hide()
	$Player.die()
	$EndSound.play()


func _on_player_hurt() -> void:
	game_over()


func _on_player_pickup(type) -> void:
	match type:
		"coin":
			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			$PoweupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
	
	score += 1
	$HUD.update_score(score)
	$CoinSound.play()

func _on_hud_start_game() -> void:
	new_game()


func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))


func _on_mobile_joystick_use_move_vector(move_vector) -> void:
	if playing == false: return
	
	$Player.joystick(move_vector)
