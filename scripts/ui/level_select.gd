extends Control
class_name LevelSelect

## ═══════════════════════════════════════
## LevelSelect.gd — Menú de selección
## ═══════════════════════════════════════

@onready var level_list: VBoxContainer = $Panel/ScrollContainer/LevelList
@onready var title_label: Label = $TitleLabel

const LEVEL_BUTTON_SCENE := preload("res://scenes/ui/level_button.tscn")


func _ready() -> void:
	print("🎛️ LevelSelect: listo, cargando niveles...")
	_populate_levels()


func _populate_levels() -> void:
	var levels := LevelDatabase.get_all_levels()
	print("📋 Niveles encontrados: %d" % levels.size())
	
	for i in range(levels.size()):
		var level: Dictionary = levels[i]
		var btn: Button = LEVEL_BUTTON_SCENE.instantiate()
		btn.text = level.get("name", "Nivel %d" % (i + 1))
		
		# Color según dificultad
		var diff: String = level.get("difficulty", "fácil")
		match diff:
			"fácil":
				btn.add_theme_color_override("font_color", Color.GREEN)
			"medio":
				btn.add_theme_color_override("font_color", Color.ORANGE)
			"difícil":
				btn.add_theme_color_override("font_color", Color.RED)
			"extremo":
				btn.add_theme_color_override("font_color", Color(0.8, 0.3, 1.0))
		var level_id: String = level.get("id", "")
		btn.pressed.connect(_on_level_selected.bind(level_id))
		
		level_list.add_child(btn)


func _on_level_selected(level_id: String) -> void:
	print("🎯 Nivel seleccionado: %s" % level_id)
	
	# Guardar selección y cambiar a la escena de juego
	GameState.selected_level = level_id
	var level_data := LevelDatabase.get_level(level_id)
	var scene_path: String = level_data.get("scene", "res://scenes/levels/nivel_01.tscn")
	get_tree().change_scene_to_file(scene_path)
