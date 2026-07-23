extends Control
class_name RetryUI

## ═══════════════════════════════════════
## RetryUI.gd — Fase 1.4
## ═══════════════════════════════════════
## UI que se muestra al morir:
## - Mensaje de muerte
## - Contador de intentos
## - Botón de reintentar

@onready var attempts_label: Label = $Panel/AttemptsLabel
@onready var retry_button: Button = $Panel/RetryButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if retry_button:
		retry_button.pressed.connect(_on_retry_pressed)
	
	# Animación de entrada
	if animation_player and animation_player.has_animation("fade_in"):
		animation_player.play("fade_in")


## Muestra la UI con el número de intentos
func show_retry(attempts: int) -> void:
	visible = true
	if attempts_label:
		attempts_label.text = "Intento #%d" % attempts
	
	if animation_player and animation_player.has_animation("fade_in"):
		animation_player.play("fade_in")


## Callback del botón de reintentar
func _on_retry_pressed() -> void:
	# Buscar el LevelManager en la escena
	var level_manager := get_tree().get_first_node_in_group("level_manager") as LevelManager
	if level_manager:
		level_manager.restart_level()
	else:
		# Fallback: recargar la escena
		get_tree().reload_current_scene()
