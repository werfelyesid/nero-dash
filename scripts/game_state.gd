extends Node

## ═══════════════════════════════════════
## GameState.gd — Estado global del juego
## ═══════════════════════════════════════

var selected_level: String = "level_01"
var unlocked_levels: Array[String] = ["level_01"]
var total_deaths: int = 0
var music_enabled: bool = true
var sfx_enabled: bool = true

## Velocidad actual del scroll (px/s) — la usan los obstáculos para moverse
var current_scroll_speed: float = 400.0

## Modo movimiento libre: el jugador controla X e Y, los obstáculos no avanzan
var free_move_mode: bool = false
