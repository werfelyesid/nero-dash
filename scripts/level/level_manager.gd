extends Node2D
class_name LevelManager

## ═══════════════════════════════════════
## LevelManager.gd — Fase 1.3-1.5
## ═══════════════════════════════════════
## Gestiona:
## - Spawning de obstáculos con timing
## - Dificultad progresiva
## - Muerte y reinicio
## - Contador de intentos

# ─── Señales ───
signal level_started
signal level_restarted

# ─── Referencias ───
@onready var player: Player = $"../Player"
@onready var spawn_marker: Marker2D = $"../SpawnPoint"
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var retry_ui: Control = $"../UI/RetryUI"

# ─── Configuración de spawning ───
const SPAWN_INTERVAL_MIN := 1.2         # segundos entre obstáculos (fácil)
const SPAWN_INTERVAL_MAX := 0.5         # segundos entre obstáculos (difícil)
const SPAWN_DISTANCE := 900.0           # px adelante del jugador donde spawnean
const DIFFICULTY_RAMP_TIME := 30.0      # segundos hasta llegar a dificultad máxima

# ─── Obstáculos disponibles ───
var obstacle_scenes: Array[PackedScene] = []

# ─── Estado ───
var spawn_timer: float = 0.0
var elapsed_time: float = 0.0
var is_running: bool = false
var total_attempts: int = 0


func _ready() -> void:
	# Cargar escenas de obstáculos
	_load_obstacles()
	
	# Conectar señal de muerte del jugador
	if player:
		player.player_died.connect(_on_player_died)
	
	# Ocultar UI de reinicio al inicio
	if retry_ui:
		retry_ui.visible = false
	
	# Iniciar el nivel
	start_level()


## Carga las escenas de obstáculos disponibles
func _load_obstacles() -> void:
	var spike_low := load("res://scenes/obstacles/spike_low.tscn")
	var spike_high := load("res://scenes/obstacles/spike_high.tscn")
	
	if spike_low:
		obstacle_scenes.append(spike_low)
	if spike_high:
		obstacle_scenes.append(spike_high)
	
	if obstacle_scenes.is_empty():
		push_warning("LevelManager: No se encontraron escenas de obstáculos.")


func _process(delta: float) -> void:
	if not is_running:
		return
	
	elapsed_time += delta
	
	# ─── Spawning de obstáculos ───
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		_spawn_obstacle()
		spawn_timer = _get_spawn_interval()


## Calcula el intervalo de spawn según la dificultad actual
func _get_spawn_interval() -> float:
	var difficulty := clampf(elapsed_time / DIFFICULTY_RAMP_TIME, 0.0, 1.0)
	return lerpf(SPAWN_INTERVAL_MIN, SPAWN_INTERVAL_MAX, difficulty)


## Genera un obstáculo aleatorio adelante del jugador
func _spawn_obstacle() -> void:
	if obstacle_scenes.is_empty():
		return
	
	# Elegir obstáculo aleatorio
	var scene: PackedScene = obstacle_scenes.pick_random()
	var obstacle: Node = scene.instantiate()
	
	# Posicionar adelante del jugador
	var spawn_x := player.global_position.x + SPAWN_DISTANCE
	obstacle.global_position = Vector2(spawn_x, 0.0)
	
	# Añadir a la escena (al mismo padre que el LevelManager)
	get_parent().add_child(obstacle)
	
	print("🚧 Obstáculo spawneado en x=%.0f | tiempo=%.1fs" % [spawn_x, elapsed_time])


## Inicia el nivel
func start_level() -> void:
	is_running = true
	elapsed_time = 0.0
	spawn_timer = 2.0  # Primer obstáculo tras 2 segundos
	level_started.emit()
	print("🎮 ¡Nivel iniciado!")


## Cuando el jugador muere
func _on_player_died() -> void:
	is_running = false
	total_attempts += 1
	
	# Mostrar UI de reinicio tras breve pausa
	await get_tree().create_timer(0.5).timeout
	if retry_ui:
		retry_ui.visible = true
		retry_ui.show_retry(total_attempts)


## Reinicia el nivel
func restart_level() -> void:
	# Reiniciar jugador
	if player:
		player.reset()
		player.global_position = Vector2(120.0, 0.0)
	
	# Eliminar todos los obstáculos existentes
	for child in get_parent().get_children():
		if child.is_in_group("obstacle"):
			child.queue_free()
	
	# Ocultar UI
	if retry_ui:
		retry_ui.visible = false
	
	# Reiniciar nivel
	start_level()
	level_restarted.emit()
	print("🔄 Nivel reiniciado. Intento #%d" % total_attempts)
