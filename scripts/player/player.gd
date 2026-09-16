extends CharacterBody2D
class_name Player

## ═══════════════════════════════════════
## Player.gd — Fase 2: El Cubo que salta
## ═══════════════════════════════════════
## El cubo se queda quieto en X (modo normal).
## En modo libre (free_move_mode) se mueve a su gusto.
## El MAPA se mueve hacia la izquierda.
## - Salto con tap (fuerza fija)
## - Gravedad simulada (invertible con portal)
## - Colisión = muerte
## - Rotación visual al saltar

# ─── Señales ───
signal player_died

# ─── Constantes de movimiento ───
const JUMP_VELOCITY := -650.0      # px/s — fuerza del salto
const GRAVITY := 1800.0            # px/s² — gravedad simulada
const FREE_MOVE_SPEED := 300.0     # px/s — velocidad en modo libre
const SHIP_RISE_SPEED := -420.0    # px/s — subida del avión al mantener pulsado
const SHIP_MAX_FALL := 650.0       # px/s — velocidad máxima de caída del avión
const ORB_BOOST := -1050.0         # px/s — impulso del orbe

# ─── Estado del jugador ───
var is_dead := false
var is_on_ground := false
var attempts := 0
var gravity_dir: int = 1           # 1 = normal, -1 = invertida
var mode: String = "cube"          # "cube" o "ship"

# ─── Referencias a nodos ───
@onready var sprite: Sprite2D = $Sprite2D
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Cámara (para seguir al jugador en modo libre)
var _camera: Camera2D = null


func _ready() -> void:
	# El jugador empieza en el tercio izquierdo de la pantalla
	# La posición se ajusta en la escena, aquí solo validamos
	if not sprite:
		push_warning("Player: No se encontró Sprite2D. Creando uno por defecto.")
		_create_default_sprite()
	
	# Buscar la cámara en la escena
	var parent := get_parent()
	if parent:
		_camera = parent.get_node_or_null("Camera2D") as Camera2D


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# ─── 1. Movimiento horizontal ───
	if GameState and GameState.free_move_mode:
		# Modo libre: moverse con flechas / A,D
		var input_dir := Input.get_axis("move_left", "move_right")
		velocity.x = input_dir * FREE_MOVE_SPEED
	else:
		# Modo normal: el cubo NO se mueve en X — el mapa lo hace
		velocity.x = 0.0
	
	# ─── 2. Gravedad y salto (según el modo) ───
	if mode == "ship":
		# Modo avión: mantener = subir, soltar = caer
		if Input.is_action_pressed("jump"):
			velocity.y = SHIP_RISE_SPEED
		else:
			velocity.y += GRAVITY * delta
			velocity.y = minf(velocity.y, SHIP_MAX_FALL)
		is_on_ground = false
	else:
		# Modo cubo: gravedad invertible y salto con tap
		var is_grounded := is_on_floor() if gravity_dir == 1 else is_on_ceiling()
		
		if not is_grounded:
			velocity.y += GRAVITY * gravity_dir * delta
			is_on_ground = false
		else:
			velocity.y = 0.0
			is_on_ground = true
		
		if Input.is_action_just_pressed("jump") and is_grounded:
			_jump()
	
	# ─── 3. Rotación visual ───
	_update_rotation(delta)
	
	# ─── 5. Aplicar movimiento ───
	move_and_slide()
	
	# ─── 5.5 Cámara sigue al jugador en modo libre ───
	_update_camera()
	
	# ─── 6. Detectar colisiones letales ───
	_check_lethal_collisions()


## Realiza el salto del jugador
func _jump() -> void:
	velocity.y = JUMP_VELOCITY * gravity_dir
	is_on_ground = false
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "scale", Vector2(0.8, 1.3), 0.08)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15)


## Establece la gravedad (1 = abajo, -1 = arriba)
func set_gravity(dir: int) -> void:
	gravity_dir = dir
	if sprite:
		sprite.scale.y = gravity_dir * abs(sprite.scale.y)
	print("🌀 Gravedad: %s" % ("arriba" if gravity_dir == -1 else "abajo"))


## Alterna la gravedad (mantenido por compatibilidad)
func invert_gravity() -> void:
	set_gravity(gravity_dir * -1)


## Cambia entre modo cubo y modo avión
func set_ship_mode(enabled: bool) -> void:
	if enabled:
		mode = "ship"
		gravity_dir = 1
		if sprite and PlaceholderAssets:
			sprite.texture = PlaceholderAssets.create_ship_sprite(56, Color(0.3, 0.9, 1.0))
			sprite.centered = true
			sprite.scale = Vector2.ONE
			sprite.rotation = 0.0
	else:
		mode = "cube"
		if sprite and PlaceholderAssets:
			sprite.texture = PlaceholderAssets.create_player_sprite(48, Color(0.0, 0.9, 1.0))
			sprite.centered = true
			sprite.scale = Vector2.ONE
			sprite.rotation = 0.0
	print("✈️ Modo: %s" % ("avión" if enabled else "cubo"))


## Impulso del orbe (salto fuerte sin necesidad de tocar el suelo)
func orb_boost() -> void:
	velocity.y = ORB_BOOST * gravity_dir
	is_on_ground = false
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "scale", Vector2(1.3, 0.8), 0.08)
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.15)


## Mueve la cámara para seguir al jugador en modo libre
func _update_camera() -> void:
	if not _camera:
		return
	
	if GameState and GameState.free_move_mode:
		# Modo libre: cámara sigue al jugador suavemente
		var target_x: float = global_position.x
		_camera.global_position.x = lerpf(_camera.global_position.x, target_x, 0.1)
	else:
		# Modo normal: cámara vuelve suavemente a su posición inicial (360)
		_camera.global_position.x = lerpf(_camera.global_position.x, 360.0, 0.05)


## Rota el sprite según el movimiento vertical
func _update_rotation(delta: float) -> void:
	if not sprite:
		return
	
	if mode == "ship":
		# El avión se inclina según su velocidad vertical
		var target_tilt: float = clampf(velocity.y / 900.0, -0.6, 0.6)
		sprite.rotation = lerpf(sprite.rotation, target_tilt, 10.0 * delta)
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
	gravity_dir = 1
	mode = "cube"
	velocity = Vector2.ZERO
	
	if sprite:
		sprite.visible = true
		sprite.rotation = 0.0
		sprite.scale = Vector2.ONE
		if PlaceholderAssets:
			sprite.texture = PlaceholderAssets.create_player_sprite(48, Color(0.0, 0.9, 1.0))
			sprite.centered = true
	
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
