extends Area2D
class_name FreeMoveZone

## ═══════════════════════════════════════
## FreeMoveZone.gd — Zona de movimiento libre
## ═══════════════════════════════════════
## Cuando el jugador entra, el auto-scroll se detiene
## y el jugador puede moverse libremente.
## Al salir, se reanuda el auto-scroll.

@export var resume_after_exit: bool = true

@onready var label: Label = $Label


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	# En modo libre, la zona se queda quieta (el jugador se mueve)
	if GameState and GameState.free_move_mode:
		return
	
	# Modo normal: la zona avanza hacia la izquierda como todo obstáculo
	var speed: float = 400.0
	if GameState:
		speed = GameState.current_scroll_speed
	position.x -= speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player and GameState:
		GameState.free_move_mode = true
		print("🆓 Modo libre ACTIVADO")


func _on_body_exited(body: Node2D) -> void:
	if body is Player and GameState and resume_after_exit:
		GameState.free_move_mode = false
		print("⏩ Auto-scroll REANUDADO")
