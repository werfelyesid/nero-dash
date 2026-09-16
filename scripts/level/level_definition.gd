class_name LevelDefinition
extends Resource

## ═══════════════════════════════════════
## LevelDefinition.gd — Fase 2
## ═══════════════════════════════════════
## Recurso que define un nivel completo:
## - Nombre, dificultad, música
## - Lista de obstáculos con timing exacto

# ─── Info del nivel ───
@export var level_name: String = "Nivel 1"
@export var difficulty: String = "fácil"    # fácil, medio, difícil
@export var level_id: String = "level_01"
@export var scroll_speed: float = 400.0       # velocidad del scroll (px/s)

# ─── Obstáculos del nivel ───
## Array de [distancia_x, tipo_obstaculo, posicion_y_opcional]
## tipo_obstaculo: "spike_low", "spike_high", "spike_double",
##                 "spike_ceiling", "block_floating", "saw"
@export var obstacles: Array = []

# ─── Color del tema ───
@export var theme_color: Color = Color(0.0, 0.9, 1.0)


## Ejemplo de cómo se ve el array de obstáculos:
## obstacles = [
##   [600, "spike_low"],
##   [900, "spike_high"],
##   [1200, "block_floating", 100],   # 100px arriba del suelo
##   [1500, "spike_double"],
##   [1800, "spike_ceiling", -80],    # 80px abajo del techo
##   [2200, "spike_low"],
## ]
##
## Cada entrada: [distancia_x: float, tipo: String, offset_y: float = 0.0]
