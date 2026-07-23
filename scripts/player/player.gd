extends CharacterBody2D
class_name Player

## ═══════════════════════════════════════
## Player.gd — Fase 1.1: El Cubo que salta
## ═══════════════════════════════════════
## Controla al personaje principal:
## - Auto-scroll horizontal
## - Salto con tap (fuerza fija)
## - Gravedad simulada
## - Colisión = muerte
## - Rotación visual al saltar

# ─── Señales ───
signal player_died

# ─── Constantes de movimiento ───
const SCROLL_SPEED := 400.0        # px/s — velocidad horizontal constante
const JUMP_VELOCITY := -650.0      # px/s — fuerza del salto (negativo = arriba)
const GRAVITY := 1800.0            # px/s² — gravedad simulada
const GROUND_Y := 0.0              # Posición Y del suelo (relativa al nivel)

# ─── Estado del jugador ───
var is_dead := false
var is_on_ground := true
var attempts := 0

# ─── Referencias a nodos ───
@onready var sprite: Sprite2D = $Sprite2D
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	# El jugador empieza en el tercio izquierdo de la pantalla
	# La posición se ajusta en la escena, aquí solo validamos
	if not sprite:
		push_warning("Player: No se encontró Sprite2D. Creando uno por defecto.")
		_create_default_sprite()


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# ─── 1. Auto-scroll horizontal ───
	velocity.x = SCROLL_SPEED
	
	# ─── 2. Gravedad ───
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		is_on_ground = false
	else:
		# Aseguramos que esté pegado al suelo
		velocity.y = 0.0
		is_on_ground = true
	
	# ─── 3. Salto (tap / click / space) ───
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jump()
	
	# ─── 4. Rotación visual al saltar ───
	_update_rotation(delta)
	
	# ─── 5. Aplicar movimiento ───
	move_and_slide()
	
	# ─── 6. Detectar colisiones letales ───
	_check_lethal_collisions()


## Realiza el salto del jugador
func _jump() -> void:
	velocity.y = JUMP_VELOCITY
	is_on_ground = false
	# Pequeño efecto: el cubo "se estira" al saltar
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "scale", Vector2(0.8, 1.3), 0.08)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15)


## Rota el sprite según el movimiento vertical
func _update_rotation(delta: float) -> void:
	if not sprite:
		return
	
	if not is_on_ground:
		# Rotación continua en el aire (gira más rápido al subir, más lento al bajar)
		var rotation_speed: float = 8.0 if velocity.y < 0 else 4.0
		sprite.rotation += rotation_speed * delta
	else:
		# En el suelo, volver suavemente a 0 (o mantener 0, 90, 180, 270)
		var target_angle: float = snapped(sprite.rotation, PI / 2.0)
		sprite.rotation = move_toward(sprite.rotation, target_angle, 12.0 * delta)


## Verifica colisiones con obstáculos (Area2D que entran en contacto)
func _check_lethal_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		
		# Si el collider está en el grupo "obstacle", es muerte
		if collider and collider.is_in_group("obstacle"):
			die()


## Maneja la muerte del jugador
func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	attempts += 1
	velocity = Vector2.ZERO
	
	print("💀 ¡Ñero muerto! Intento #%d" % attempts)
	
	# Efecto visual de muerte
	if death_particles:
		death_particles.emitting = true
	
	# Ocultar sprite
	if sprite:
		sprite.visible = false
	
	# Desactivar colisiones
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	
	# Emitir señal para que el level manager muestre reinicio
	player_died.emit()


## Reinicia el jugador para otro intento
func reset() -> void:
	is_dead = false
	is_on_ground = true
	velocity = Vector2.ZERO
	
	if sprite:
		sprite.visible = true
		sprite.rotation = 0.0
		sprite.scale = Vector2.ONE
	
	if collision_shape:
		collision_shape.set_deferred("disabled", false)
	
	if death_particles:
		death_particles.emitting = false


## Crea un sprite por defecto si no hay uno en la escena
func _create_default_sprite() -> void:
	var new_sprite := Sprite2D.new()
	new_sprite.name = "Sprite2D"
	new_sprite.centered = true
	
	# Usar el generador de assets procedurales
	if PlaceholderAssets:
		new_sprite.texture = PlaceholderAssets.create_player_sprite(48, Color(0.0, 0.9, 1.0))
	else:
		# Fallback manual si no está el autoload
		var image := Image.create(48, 48, false, Image.FORMAT_RGBA8)
		image.fill(Color(0.0, 0.9, 1.0, 1.0))
		var texture := ImageTexture.create_from_image(image)
		new_sprite.texture = texture
	
	add_child(new_sprite)
	sprite = new_sprite
	print("Player: Sprite por defecto creado (cuadrado cyan 48x48)")
