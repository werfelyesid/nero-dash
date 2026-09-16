extends Area2D
class_name ObstacleBase

## ═══════════════════════════════════════
## ObstacleBase.gd — Fase 2
## ═══════════════════════════════════════
## Clase base para TODOS los obstáculos.
## - Se mueven hacia la izquierda (el mapa avanza)
## - Se destruyen al salir de pantalla

# ─── Propiedades base ───
@export var obstacle_type: String = "generic"
@export var damage := 1

# ─── Referencias ───
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	add_to_group("obstacle")
	
	if sprite and sprite.texture == null and PlaceholderAssets:
		_assign_procedural_texture()
		sprite.centered = true
	
	body_entered.connect(_on_body_entered)
	
	if animation_player and animation_player.has_animation("float"):
		animation_player.play("float")


func _physics_process(delta: float) -> void:
	# ─── Si estamos en modo libre, no moverse ───
	if GameState and GameState.free_move_mode:
		return
	
	# ─── Moverse hacia la izquierda ───
	var speed: float = 400.0
	if GameState:
		speed = GameState.current_scroll_speed
	position.x -= speed * delta


## Asigna una textura procedural según el nombre del nodo raíz
func _assign_procedural_texture() -> void:
	var parent_name := get_parent() if get_parent() else self
	var scene_name := owner.name if owner else name
	
	match name.to_lower():
		"spikedouble":
			sprite.texture = PlaceholderAssets.create_spike_double_sprite()
		"spikeceiling":
			sprite.texture = PlaceholderAssets.create_spike_ceiling_sprite()
		"blockfloating":
			sprite.texture = PlaceholderAssets.create_block_floating_sprite()
		"spikelow":
			sprite.texture = PlaceholderAssets.create_spike_low_sprite()
		"spikehigh":
			sprite.texture = PlaceholderAssets.create_spike_high_sprite()
		_:
			sprite.texture = PlaceholderAssets.create_spike_low_sprite()


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
