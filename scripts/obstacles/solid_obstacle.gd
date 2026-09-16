extends StaticBody2D
class_name SolidObstacle

## ═══════════════════════════════════════
## SolidObstacle.gd — Plataforma sólida
## ═══════════════════════════════════════
## El jugador PUEDE pararse encima.
## NO mata — solo sirve de plataforma.

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	# NO agregar al grupo "obstacle" — las plataformas no matan
	if sprite and sprite.texture == null and PlaceholderAssets:
		sprite.texture = PlaceholderAssets.create_solid_block_sprite()
		sprite.centered = true


func _physics_process(delta: float) -> void:
	# ─── Si estamos en modo libre, no moverse ───
	if GameState and GameState.free_move_mode:
		return
	
	var speed: float = 400.0
	if GameState:
		speed = GameState.current_scroll_speed
	position.x -= speed * delta
