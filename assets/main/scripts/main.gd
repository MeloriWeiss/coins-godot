extends Node2D

@export var coin_scene : PackedScene
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


func _process(delta: float) -> void:
	#проверяем, закончен ли уровень
	if playing and get_tree().get_nodes_in_group("Coins").size() == 0:
		new_level()


func new_game():
	#подготавливаем сцены при старте
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func spawn_coins():
	#увеличиваем количество монеток с каждым уровнем
	for i in level + 4:
		#инстанцируем сцену с монетками
		var c = coin_scene.instantiate()
		add_child(c)
		#устанавливаем сцене размер окна
		c.screensize = screensize
		#задаём случайную позицию
		c.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))

func new_level():
	level += 1
	time_left += 5
	spawn_coins()


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
	#показываем интерфейс окончания игры
	$HUD.show_game_over()
	$Player.die()


func _on_player_hurt() -> void:
	game_over()


func _on_player_pickup() -> void:
	score += 1
	$HUD.update_score(score)

func _on_hud_start_game() -> void:
	new_game()
