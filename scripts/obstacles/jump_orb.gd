extends Area2D
class_name JumpOrb

## ═══════════════════════════════════════
## JumpOrb.gd — Orbe de salto
## ═══════════════════════════════════════
## NO tiene colisión: el jugador lo atraviesa libremente.
## Si el jugador pulsa SALTO mientras está encima,
## recibe un impulso fuerte y el orbe se consume.

@onready var sprite: Sprite2D = $Sprite2D

var _player_inside: Player = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if sprite and sprite.texture == null and PlaceholderAssets:
		sprite.texture = PlaceholderAssets.create_orb_sprite(48, Color(1.0, 0.8, 0.2))
		sprite.centered = true


func _physics_process(delta: float) -> void:
	if GameState and GameState.free_move_mode:
		return
	
	var speed: float = 400.0
	if GameState:
		speed = GameState.current_scroll_speed
	position.x -= speed * delta
	
	# Si el jugador está dentro y pulsa salto → boost
	if _player_inside and Input.is_action_just_pressed("jump"):
		_player_inside.orb_boost()
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_inside = body


func _on_body_exited(body: Node2D) -> void:
	if body is Player and _player_inside == body:
		_player_inside = null
