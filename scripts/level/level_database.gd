extends Node

## ═══════════════════════════════════════
## LevelDatabase.gd — Catálogo de niveles
## ═══════════════════════════════════════
## Define TODOS los niveles del juego.
## Cada nivel es un diccionario con obstáculos.
##
## Formato de obstáculo:
##   { "x": distancia, "type": tipo, "y": offset_y (opcional) }
##
## Tipos disponibles:
##   "spike_low"     — Pincho bajo (suelo)
##   "spike_high"    — Pincho alto (suelo)
##   "spike_double"  — Pincho doble (suelo)
##   "spike_ceiling" — Pincho de techo (cuelga)
##   "block_floating"— Bloque flotante (aire)

# ─── Niveles disponibles ───
var levels: Array = []


func _ready() -> void:
	_build_levels()


func _build_levels() -> void:
	levels = [
		{
			"id": "level_01",
			"name": "🌱 Primeros Pasos",
			"difficulty": "fácil",
			"scroll_speed": 320.0,
			"bpm": 110,
			"theme_color": Color(0.0, 0.9, 1.0),
			"music": "res://assets/music/alexguz-funk-amp-breakbeat-541097.mp3",
			"scene": "res://scenes/levels/nivel_01.tscn",
			"obstacles": [
				{"beat": 4, "type": "spike_low"},
				{"beat": 8, "type": "spike_low"},
				{"beat": 12, "type": "spike_high"},
				{"beat": 16, "type": "spike_low"},
				{"beat": 20, "type": "spike_low"},
				{"beat": 24, "type": "spike_high"},
				{"beat": 28, "type": "spike_low"},
				{"beat": 32, "type": "spike_low"},
				{"beat": 36, "type": "spike_high"},
				{"beat": 40, "type": "spike_low"},
				{"beat": 44, "type": "spike_low"},
				{"beat": 48, "type": "spike_high"},
				{"beat": 52, "type": "spike_low"},
			]
		},
		{
			"id": "level_02",
			"name": "⚡ Ritmo Callejero",
			"difficulty": "medio",
			"scroll_speed": 420.0,
			"bpm": 150,
			"theme_color": Color(1.0, 0.5, 0.0),
			"music": "res://assets/music/u_vozrr51b1t-3-05-electroman-adventures-478937.mp3",
			"scene": "res://scenes/levels/nivel_02.tscn",
			"obstacles": [
				{"beat": 4, "type": "spike_low"},
				{"beat": 8, "type": "spike_high"},
				{"beat": 12, "type": "spike_double"},
				{"beat": 16, "type": "block_floating", "y": -120},
				{"beat": 20, "type": "spike_high"},
				{"beat": 24, "type": "spike_low"},
				{"beat": 28, "type": "spike_double"},
				{"beat": 32, "type": "spike_ceiling", "y": -840},
				{"beat": 36, "type": "spike_low"},
				{"beat": 40, "type": "block_floating", "y": -140},
				{"beat": 44, "type": "spike_high"},
				{"beat": 48, "type": "spike_double"},
				{"beat": 52, "type": "spike_low"},
				{"beat": 56, "type": "spike_ceiling", "y": -840},
				{"beat": 60, "type": "spike_high"},
				{"beat": 64, "type": "block_floating", "y": -130},
			]
		},
		{
			"id": "level_03",
			"name": "💀 Callejón Sin Salida",
			"difficulty": "difícil",
			"scroll_speed": 480.0,
			"bpm": 150,
			"theme_color": Color(1.0, 0.15, 0.15),
			"music": "res://assets/music/cg6-cyber-jump-499060.mp3",
			"scene": "res://scenes/levels/nivel_03.tscn",
			"obstacles": [
				{"beat": 4, "type": "spike_double"},
				{"beat": 7, "type": "spike_high"},
				{"beat": 10, "type": "block_floating", "y": -130},
				{"beat": 14, "type": "spike_ceiling", "y": -840},
				{"beat": 17, "type": "spike_double"},
				{"beat": 20, "type": "spike_low"},
				{"beat": 24, "type": "spike_high"},
				{"beat": 27, "type": "block_floating", "y": -150},
				{"beat": 30, "type": "spike_ceiling", "y": -840},
				{"beat": 34, "type": "spike_double"},
				{"beat": 37, "type": "spike_low"},
				{"beat": 40, "type": "spike_high"},
				{"beat": 44, "type": "block_floating", "y": -120},
				{"beat": 47, "type": "spike_ceiling", "y": -840},
				{"beat": 50, "type": "spike_double"},
				{"beat": 54, "type": "spike_high"},
				{"beat": 57, "type": "block_floating", "y": -140},
				{"beat": 60, "type": "spike_ceiling", "y": -840},
				{"beat": 64, "type": "spike_double"},
			]
		},
		{
			"id": "t8mex",
			"name": "🌌 t8mex",
			"difficulty": "extremo",
			"scroll_speed": 520.0,
			"bpm": 140,
			"theme_color": Color(0.6, 0.2, 1.0),
			"music": "res://assets/music/t8mex.mp3",
			"scene": "res://scenes/levels/t8mex.tscn",
			"obstacles": []
		},
	]


## Retorna un nivel por su ID
func get_level(level_id: String) -> Dictionary:
	for level in levels:
		if level["id"] == level_id:
			return level
	return levels[0]  # fallback: primer nivel


## Retorna todos los niveles
func get_all_levels() -> Array:
	return levels
