extends Area2D
class_name ObstacleBase

## ═══════════════════════════════════════
## ObstacleBase.gd — Fase 1.3
## ═══════════════════════════════════════
## Clase base para TODOS los obstáculos.
## Cada obstáculo hereda de aquí y define:
## - Su sprite/forma
## - Su tipo de movimiento (si aplica)
## - Su comportamiento único

# ─── Propiedades base ───
@export var obstacle_type: String = "generic"
@export var damage := 1

# ─── Referencias ───
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	# Todos los obstáculos pertenecen al grupo "obstacle"
	add_to_group("obstacle")
	
	# Generar textura procedural si no hay sprite asignado
	if sprite and sprite.texture == null and PlaceholderAssets:
		sprite.texture = PlaceholderAssets.create_spike_low_sprite()
		sprite.centered = true
	
	# Conectar señal de colisión (body_entered)
	body_entered.connect(_on_body_entered)
	
	# Iniciar animación si existe
	if animation_player and animation_player.has_animation("float"):
		animation_player.play("float")


## Cuando un cuerpo entra en el área de colisión
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_on_player_hit(body)


## Llamado cuando el jugador choca con este obstáculo
func _on_player_hit(player: Player) -> void:
	player.die()
	_on_hit_effect()


## Efecto visual/sonido al ser golpeado (override en hijos)
func _on_hit_effect() -> void:
	# Por defecto: pequeño flash rojo
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "modulate", Color.RED, 0.05)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
