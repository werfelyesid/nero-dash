extends Node2D
class_name LevelManager

## ═══════════════════════════════════════
## LevelManager.gd — ¡Modo Editor Visual!
## ═══════════════════════════════════════
## Pon los obstáculos en el nodo "LevelObstacles"
## y muévelos en el editor como quieras.

signal level_started
signal level_completed

@onready var player: Player = $"../Player"
@onready var retry_ui: Control = $"../UI/RetryUI"
@onready var win_ui: Control = $"../UI/WinUI"
@onready var hud: HUD = $"../UI/HUD"
@onready var music_player: AudioStreamPlayer = $"../MusicPlayer"
@onready var level_obstacles: Node2D = $"../LevelObstacles"

var current_level: Dictionary = {}
var current_scroll_speed: float = 400.0
var level_duration: float = 30.0    # duración en segundos
var total_attempts: int = 0
var elapsed_time: float = 0.0
var is_running: bool = false


func _ready() -> void:
	if player:
		player.player_died.connect(_on_player_died)
	_connect_obstacles()
	
	var level_id: String = "level_01"
	if GameState:
		level_id = GameState.selected_level
	start_level(level_id)


func _connect_obstacles() -> void:
	if not level_obstacles:
		return
	# Conectar TODOS los Area2D (spikes, killzones) que estén en LevelObstacles
	for child in level_obstacles.get_children():
		_connect_recursive(child)


func _connect_recursive(node: Node) -> void:
	# Ignorar nodos KillZone (ya no se usan)
	if "KillZone" in node.name:
		return
	
	if node is Area2D:
		node.add_to_group("obstacle")
		if not node.body_entered.is_connected(_on_obstacle_hit):
			node.body_entered.connect(_on_obstacle_hit.bind(node))
	for child in node.get_children():
		_connect_recursive(child)


func _on_obstacle_hit(body: Node2D, _obs: Node) -> void:
	if body is Player:
		body.die()


func load_level(level_id: String) -> void:
	current_level = LevelDatabase.get_level(level_id)
	current_scroll_speed = current_level.get("scroll_speed", 400.0)
	GameState.current_scroll_speed = current_scroll_speed
	
	# Los obstáculos ya están en la escena del nivel (no se cargan dinámicamente)
	
	# Duración del nivel
	var bpm: float = current_level.get("bpm", 120.0)
	var obs: Array = current_level.get("obstacles", [])
	if not obs.is_empty():
		var last: Dictionary = obs[-1]
		level_duration = last.get("beat", 40.0) * (60.0 / bpm) + 2.0
	else:
		level_duration = 999.0  # Sin límite de tiempo — el nivel termina cuando acaba la música
	
	if music_player:
		music_player.stop()
		var path: String = current_level.get("music", "")
		if not path.is_empty():
			var m: AudioStream = load(path)
			if m:
				music_player.stream = m
				music_player.play()


func start_level(level_id: String = "level_01") -> void:
	load_level(level_id)
	elapsed_time = 0.0
	total_attempts = 0
	is_running = true
	
	# Resetear modo libre al iniciar/reiniciar
	if GameState:
		GameState.free_move_mode = false
	
	if player:
		player.reset()
		player.global_position = Vector2(30, 600)
	if retry_ui: retry_ui.visible = false
	if win_ui: win_ui.visible = false
	if hud:
		hud.update_time(0.0)
		hud.update_attempts(0)
	level_started.emit()


func _physics_process(delta: float) -> void:
	if not is_running:
		return
	elapsed_time += delta
	
	if hud:
		hud.update_time(elapsed_time)
	
	# ¿Se acabó el tiempo del nivel?
	if elapsed_time >= level_duration:
		_complete_level()


func _complete_level() -> void:
	if not is_running: return
	is_running = false
	if music_player: music_player.stop()
	if win_ui:
		win_ui.visible = true
		win_ui.show_win(elapsed_time, total_attempts)
	level_completed.emit()


func _on_player_died() -> void:
	is_running = false
	total_attempts += 1
	if hud: hud.update_attempts(total_attempts)
	await get_tree().create_timer(0.5).timeout
	if retry_ui:
		retry_ui.visible = true
		retry_ui.show_retry(total_attempts)


func restart_level() -> void:
	if player:
		player.reset()
		player.global_position = Vector2(30, 600)
	start_level(current_level.get("id", "level_01"))
