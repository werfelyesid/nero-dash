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
	
	var tex := ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex


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


## Aplica textura procedural a un sprite si no tiene una asignada
func apply_if_empty(sprite: Sprite2D, generator: Callable) -> void:
	if sprite.texture == null:
		sprite.texture = generator.call()
