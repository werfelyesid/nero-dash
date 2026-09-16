extends Area2D
class_name ModePortal

## ═══════════════════════════════════════
## ModePortal.gd — Cambia el modo del jugador
## ═══════════════════════════════════════
## - to_ship = true  → convierte al jugador en AVIÓN
## - to_ship = false → lo devuelve a CUBO

## Si es true, el jugador pasa a modo avión
@export var to_ship: bool = true

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	if sprite and sprite.texture == null and PlaceholderAssets:
		# Cian = avión, verde = cubo
		var portal_color: Color = Color(0.4, 0.9, 1.0) if to_ship else Color(0.3, 0.9, 0.5)
		sprite.texture = PlaceholderAssets.create_portal_sprite(56, portal_color)
		sprite.centered = true


func _physics_process(delta: float) -> void:
	if GameState and GameState.free_move_mode:
		return
	
	var speed: float = 400.0
	if GameState:
		speed = GameState.current_scroll_speed
	position.x -= speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_ship_mode(to_ship)
		queue_free()
