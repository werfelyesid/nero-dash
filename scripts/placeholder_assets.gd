extends Node

## ═══════════════════════════════════════
## PlaceholderAssets.gd — Generador de texturas
## ═══════════════════════════════════════
## Autoload que genera sprites procedurales
## para desarrollo rápido sin assets externos.
##
## ⚠️ En producción, se reemplazan por assets reales.

# ─── Texturas cacheadas ───
var _cache: Dictionary = {}


## Genera una textura de cuadrado (para el jugador)
func create_player_sprite(size: int = 48, color: Color = Color(0.0, 0.9, 1.0)) -> ImageTexture:
	var key := "player_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(color)
	
	# Borde interior oscuro (2px)
	var border_color := color.darkened(0.4)
	for i in range(size):
		for j in range(size):
			if i < 2 or i >= size - 2 or j < 2 or j >= size - 2:
				img.set_pixel(i, j, border_color)
	
	# Brillo en la esquina superior izquierda
	var highlight := color.lightened(0.3)
	for i in range(2, 10):
		for j in range(2, 10):
			if img.get_pixel(i, j) == color:
				img.set_pixel(i, j, highlight)
	
	# ─── Cara: ojos y boca ───
	var eye_white := Color.WHITE
	var eye_pupil := Color(0.05, 0.05, 0.05)
	var eye_half: int = maxi(3, size / 10)
	var eye_y: int = size / 3
	var mouth_y: int = size * 2 / 3
	
	_draw_eye(img, size / 3, eye_y, eye_half, eye_white, eye_pupil)
	_draw_eye(img, size * 2 / 3, eye_y, eye_half, eye_white, eye_pupil)
	
	# Boca (línea oscura)
	for x in range(size / 4, size * 3 / 4):
		img.set_pixel(x, mouth_y, eye_pupil)
		img.set_pixel(x, mouth_y + 1, eye_pupil)
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Helper: dibuja un ojo (cuadrado blanco con pupila negra)
func _draw_eye(img: Image, cx: int, cy: int, half: int, white: Color, pupil: Color) -> void:
	for y in range(cy - half, cy + half + 1):
		for x in range(cx - half, cx + half + 1):
			if x < 0 or x >= img.get_width() or y < 0 or y >= img.get_height():
				continue
			img.set_pixel(x, y, white)
	var p_half: int = maxi(1, half / 2)
	for y in range(cy - p_half, cy + p_half + 1):
		for x in range(cx - p_half, cx + p_half + 1):
			if x < 0 or x >= img.get_width() or y < 0 or y >= img.get_height():
				continue
			img.set_pixel(x, y, pupil)


## Genera una textura de triángulo/pincho bajo
func create_spike_low_sprite(size: int = 48, color: Color = Color(1.0, 0.2, 0.2)) -> ImageTexture:
	var key := "spike_low_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	var center_x := size / 2.0
	var tip_y := 4.0
	var base_y := size - 4.0
	var half_base := size / 2.0 - 4.0
	
	# Dibujar triángulo
	for y in range(size):
		for x in range(size):
			var progress := (y - tip_y) / (base_y - tip_y)
			var half_width := lerpf(4.0, half_base, progress)
			if x >= center_x - half_width and x <= center_x + half_width:
				if y >= tip_y and y <= base_y:
					img.set_pixel(x, y, color)
	
	# Borde
	var border_color: Color = color.darkened(0.3)
	for y in range(size):
		for x in range(size):
			if img.get_pixel(x, y) == color:
				# Verificar si es borde
				var is_border: bool = false
				for dy in [-1, 0, 1]:
					for dx in [-1, 0, 1]:
						var nx: int = x + dx
						var ny: int = y + dy
						if nx < 0 or nx >= size or ny < 0 or ny >= size:
							is_border = true
						elif img.get_pixel(nx, ny) == Color.TRANSPARENT:
							is_border = true
				if is_border:
					img.set_pixel(x, y, border_color)
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Genera una textura de pincho alto
func create_spike_high_sprite() -> ImageTexture:
	return create_spike_low_sprite(64, Color(1.0, 0.15, 0.15))


## Genera una textura de pincho doble (dos triángulos)
func create_spike_double_sprite(size: int = 64, color: Color = Color(1.0, 0.1, 0.1)) -> ImageTexture:
	var key := "spike_double_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	var third := size / 3
	
	# Triángulo izquierdo
	_draw_triangle(img, 0, third * 2, size / 2, third, color)
	# Triángulo derecho
	_draw_triangle(img, size / 2, third * 2, size, third, color)
	
	_apply_border(img, color)
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Genera una textura de pincho de techo (triángulo invertido)
func create_spike_ceiling_sprite(size: int = 48, color: Color = Color(0.9, 0.1, 0.5)) -> ImageTexture:
	var key := "spike_ceiling_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	# Triángulo invertido: base arriba, punta abajo
	_draw_triangle(img, 0, size / 4, size, size - 4, color)
	
	_apply_border(img, color)
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Genera una textura de bloque flotante (cuadrado naranja)
func create_block_floating_sprite(size: int = 48, color: Color = Color(1.0, 0.6, 0.1)) -> ImageTexture:
	var key := "block_float_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(color)
	
	# Borde más oscuro
	var border_color: Color = color.darkened(0.4)
	for i in range(size):
		for j in range(size):
			if i < 3 or i >= size - 3 or j < 3 or j >= size - 3:
				img.set_pixel(i, j, border_color)
	
	# Símbolo "!" en el centro
	var warn_color := Color.BLACK
	var cx := size / 2
	var cy := size / 2
	for i in range(cx - 3, cx + 3):
		for j in range(size / 4, size * 3 / 4):
			if j < cy + 4 and j > cy - 2:
				continue
			if img.get_pixel(i, j) == color:
				img.set_pixel(i, j, warn_color)
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Helper: dibuja un triángulo en la imagen
func _draw_triangle(img: Image, x1: float, y1: float, x2: float, y2: float, color: Color) -> void:
	var top_x := (x1 + x2) / 2.0
	var top_y := minf(y1, y2)
	var base_y := maxf(y1, y2)
	
	for y in range(img.get_height()):
		for x in range(img.get_width()):
			var progress := (y - top_y) / (base_y - top_y) if base_y != top_y else 0.0
			var half_width := lerpf(2.0, (x2 - x1) / 2.0, progress)
			if x >= top_x - half_width and x <= top_x + half_width:
				if y >= top_y and y <= base_y:
					img.set_pixel(x, y, color)


## Helper: aplica borde oscuro a píxeles coloreados
func _apply_border(img: Image, original_color: Color) -> void:
	var border_color: Color = original_color.darkened(0.35)
	var size := img.get_width()
	for y in range(size):
		for x in range(size):
			if img.get_pixel(x, y) == original_color:
				var is_border: bool = false
				for dy in [-1, 0, 1]:
					for dx in [-1, 0, 1]:
						var nx: int = x + dx
						var ny: int = y + dy
						if nx < 0 or nx >= size or ny < 0 or ny >= size:
							is_border = true
						elif img.get_pixel(nx, ny) == Color.TRANSPARENT:
							is_border = true
				if is_border:
					img.set_pixel(x, y, border_color)


## Aplica textura procedural a un sprite si no tiene una asignada
func apply_if_empty(sprite: Sprite2D, generator: Callable) -> void:
	if sprite.texture == null:
		sprite.texture = generator.call()


## Genera textura de fruta 🍎 (manzana roja con hojita verde)
func create_fruit_sprite(size: int = 56) -> ImageTexture:
	var key := "fruit_%d" % size
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	var center := Vector2(size / 2.0, size / 2.0 + 4)
	var fruit_radius := size / 2.0 - 4
	var fruit_color := Color(0.9, 0.15, 0.1, 1.0)  # Rojo manzana
	
	# ─── Cuerpo de la fruta (círculo rojo) ───
	for y in range(size):
		for x in range(size):
			var dist := Vector2(x - center.x, y - center.y).length()
			if dist <= fruit_radius:
				# Degradado: más oscuro en los bordes
				var t := dist / fruit_radius
				var col := fruit_color.lerp(fruit_color.darkened(0.4), t * t)
				img.set_pixel(x, y, col)
	
	# ─── Brillo (reflejo blanco) ───
	var highlight_center := Vector2(center.x - fruit_radius * 0.3, center.y - fruit_radius * 0.3)
	for y in range(size):
		for x in range(size):
			var dist := Vector2(x - highlight_center.x, y - highlight_center.y).length()
			if dist <= fruit_radius * 0.25 and img.get_pixel(x, y).a > 0:
				img.set_pixel(x, y, img.get_pixel(x, y).lightened(0.5))
	
	# ─── Tallo (marrón) ───
	var stem_color := Color(0.4, 0.25, 0.1, 1.0)
	var stem_top := center.y - fruit_radius - 2
	for y in range(maxi(0, int(stem_top - 8)), int(stem_top + 2)):
		for x in range(int(center.x - 2), int(center.x + 2)):
			if y >= 0 and y < size and x >= 0 and x < size:
				img.set_pixel(x, y, stem_color)
	
	# ─── Hojita verde ───
	var leaf_color := Color(0.15, 0.7, 0.15, 1.0)
	var leaf_base := Vector2(center.x, stem_top + 2)
	var leaf_tip := Vector2(center.x + 14, stem_top - 6)
	for y in range(size):
		for x in range(size):
			var p := Vector2(x, y)
			# Forma de hoja: óvalo inclinado
			var dx := p.x - leaf_base.x
			var dy := p.y - leaf_base.y
			var along := dx * 0.7 + dy * (-0.7)   # Proyección hacia la punta
			var across := dx * 0.7 + dy * 0.7
			var leaf_len := 14.0
			var leaf_width := 5.0
			if along > 0 and along < leaf_len:
				var max_w := leaf_width * (1.0 - along / leaf_len) * sin(along / leaf_len * PI)
				if abs(across) < max_w:
					img.set_pixel(x, y, leaf_color)
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Genera textura para portal de gravedad (círculo morado con borde)
func create_portal_sprite(size: int = 56, color: Color = Color(0.6, 0.2, 1.0)) -> ImageTexture:
	var key := "portal_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	var center := size / 2.0
	var outer_r := size / 2.0 - 2
	var inner_r := size / 2.0 - 10
	
	# Círculo exterior
	for y in range(size):
		for x in range(size):
			var dist := Vector2(x - center, y - center).length()
			if dist <= outer_r and dist >= inner_r:
				img.set_pixel(x, y, color)
			elif dist <= inner_r and dist >= inner_r - 3:
				img.set_pixel(x, y, color.lightened(0.3))
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Genera textura de avión/nave (triángulo apuntando a la derecha)
func create_ship_sprite(size: int = 56, color: Color = Color(0.3, 0.9, 1.0)) -> ImageTexture:
	var key := "ship_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	var cy := size / 2.0
	var nose_x := size - 3.0
	var tail_x := 3.0
	var tail_half := size * 0.38
	var nose_half := 2.0
	
	for y in range(size):
		for x in range(size):
			var t := (x - tail_x) / (nose_x - tail_x)
			var half_w := lerpf(tail_half, nose_half, t)
			if absf(y - cy) <= half_w and x >= tail_x and x <= nose_x:
				img.set_pixel(x, y, color)
	
	# Cabina (punto claro cerca de la nariz)
	var cockpit := color.lightened(0.6)
	var cockpit_cx := int(size * 0.72)
	for y in range(int(cy) - 3, int(cy) + 4):
		for x in range(cockpit_cx - 3, cockpit_cx + 4):
			if x >= 0 and x < size and y >= 0 and y < size:
				if img.get_pixel(x, y) == color:
					img.set_pixel(x, y, cockpit)
	
	_apply_border(img, color)
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Genera textura de orbe brillante (círculo con degradado)
func create_orb_sprite(size: int = 48, color: Color = Color(1.0, 0.8, 0.2)) -> ImageTexture:
	var key := "orb_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	var center := size / 2.0
	var radius := size / 2.0 - 2
	for y in range(size):
		for x in range(size):
			var dist := Vector2(x - center, y - center).length()
			if dist <= radius:
				var t := dist / radius
				img.set_pixel(x, y, color.lightened(0.4).lerp(color.darkened(0.2), t))
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


## Genera textura para bloques sólidos (verde)
func create_solid_block_sprite(size: int = 48, color: Color = Color(0.3, 0.8, 0.3)) -> ImageTexture:
	var key := "solid_%d_%s" % [size, color.to_html()]
	if _cache.has(key):
		return _cache[key]
	
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(color)
	
	var border_color: Color = color.darkened(0.35)
	for i in range(size):
		for j in range(size):
			if i < 3 or i >= size - 3 or j < 3 or j >= size - 3:
				img.set_pixel(i, j, border_color)
	
	# Línea superior blanca (indica que es "parables" encima)
	for i in range(6, size - 6):
		for j in range(3, 6):
			img.set_pixel(i, j, Color.WHITE)
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex
