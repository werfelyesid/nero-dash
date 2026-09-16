extends Control
class_name WinUI

## ═══════════════════════════════════════
## WinUI.gd — Pantalla de victoria
## ═══════════════════════════════════════

@onready var time_label: Label = $Panel/TimeLabel
@onready var attempts_label: Label = $Panel/AttemptsLabel
@onready var next_button: Button = $Panel/NextButton
@onready var menu_button: Button = $Panel/MenuButton


func _ready() -> void:
	if next_button:
		next_button.pressed.connect(_on_next_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)


func show_win(time_val: float, attempts: int) -> void:
	visible = true
	
	var mins: int = int(time_val) / 60
	var secs: int = int(time_val) % 60
	
	if time_label:
		time_label.text = "Tiempo: %02d:%02d" % [mins, secs]
	if attempts_label:
		attempts_label.text = "Intentos: %d" % attempts


func _on_next_pressed() -> void:
	var lm := get_tree().get_first_node_in_group("level_manager")
	if not lm:
		# Buscar LevelManager en la escena
		lm = get_tree().root.get_node_or_null("MainLevel/LevelManager") as LevelManager
	
	if lm:
		# Siguiente nivel (cíclico)
		var current_id: String = lm.current_level.get("id", "level_01")
		var levels := LevelDatabase.get_all_levels()
		var next_idx := 0
		for i in range(levels.size()):
			if levels[i]["id"] == current_id:
				next_idx = (i + 1) % levels.size()
				break
		lm.start_level(levels[next_idx]["id"])
	else:
		get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn")
