extends Area2D
class_name ColorZone

## ═══════════════════════════════════════
## ColorZone.gd — Cambia el color del fondo
## ═══════════════════════════════════════
## Cuando el jugador entra, el fondo cambia de color
## suavemente. Al salir, vuelve al color original.

## Color al que cambia el fondo al entrar
@export var zone_color: Color = Color(1.0, 0.55, 0.0, 1.0)

var _background: ColorRect = null
var _original_color: Color = Color.WHITE
var _tween: Tween = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_background = _find_background()
	if _background:
		_original_color = _background.color


func _physics_process(delta: float) -> void:
	# En modo libre, la zona se queda quieta
	if GameState and GameState.free_move_mode:
		return
	
	# Modo normal: avanza hacia la izquierda como todo obstáculo
	var speed: float = 400.0
	if GameState:
		speed = GameState.current_scroll_speed
	position.x -= speed * delta


## Busca el nodo "Background" subiendo por el árbol de escena
func _find_background() -> ColorRect:
	var node := get_parent()
	while node:
		var bg := node.get_node_or_null("Background") as ColorRect
		if bg:
			return bg
		node = node.get_parent()
	return null


func _on_body_entered(body: Node2D) -> void:
	if body is Player and _background:
		_change_color(zone_color)


func _on_body_exited(body: Node2D) -> void:
	if body is Player and _background:
		_change_color(_original_color)


## Cambia el color del fondo suavemente (Tween)
func _change_color(target: Color) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_background, "color", target, 0.5)
