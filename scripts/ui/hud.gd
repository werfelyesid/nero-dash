extends Control
class_name HUD

## ═══════════════════════════════════════
## HUD.gd — Fase 1.5
## ═══════════════════════════════════════
## Muestra información en pantalla:
## - Tiempo transcurrido
## - Intentos
## - Botón de pausa (futuro)

@onready var time_label: Label = $TimeLabel
@onready var attempts_label: Label = $AttemptsLabel


func _ready() -> void:
	update_attempts(0)
	update_time(0.0)


func update_time(seconds: float) -> void:
	if time_label:
		var mins := int(seconds) / 60
		var secs := int(seconds) % 60
		time_label.text = "%02d:%02d" % [mins, secs]


func update_attempts(count: int) -> void:
	if attempts_label:
		attempts_label.text = "Intentos: %d" % count
