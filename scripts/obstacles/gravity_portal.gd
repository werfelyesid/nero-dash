extends Area2D
class_name GravityPortal

## ═══════════════════════════════════════
## GravityPortal.gd — Portal de gravedad
## ═══════════════════════════════════════
## Cambia la gravedad del jugador al atravesarlo.
## - target_gravity = 1  → gravedad hacia ABAJO (normal)
## - target_gravity = -1 → gravedad hacia ARRIBA (invertida)

## Dirección de gravedad que aplica este portal
@export var target_gravity: int = 1   # 1 = abajo, -1 = arriba

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	if sprite and sprite.texture == null and PlaceholderAssets:
		# Azul = portal hacia arriba, naranja = portal hacia abajo
		var portal_color: Color = Color(0.2, 0.8, 1.0) if target_gravity == -1 else Color(1.0, 0.6, 0.1)
		sprite.texture = PlaceholderAssets.create_portal_sprite(56, portal_color)
		sprite.centered = true


func _physics_process(delta: float) -> void:
	# En modo libre, el portal se queda quieto
	if GameState and GameState.free_move_mode:
		return
	
	var speed: float = 400.0
	if GameState:
		speed = GameState.current_scroll_speed
	position.x -= speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_gravity(target_gravity)
		queue_free()
