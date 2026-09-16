extends Node2D
class_name LevelObstacles

## ═══════════════════════════════════════
## LevelObstacles.gd — Contenedor de obstáculos
## ═══════════════════════════════════════
## Pega esta escena como hija de MainLevel.
## Todos los obstáculos hijos se moverán automáticamente.

const DESPAWN_X: float = -200.0


func _ready() -> void:
	# Marcar todos los hijos Area2D como obstáculos
	for child in get_children():
		if child is Area2D:
			child.add_to_group("obstacle")
			child.body_entered.connect(_on_obstacle_hit.bind(child))
		
		if child is StaticBody2D:
			child.add_to_group("obstacle")
			# Para solid obstacles, buscar KillZone
			var kill_zone := child.get_node_or_null("KillZone") as Area2D
			if kill_zone:
				kill_zone.body_entered.connect(_on_obstacle_hit.bind(kill_zone))


func _physics_process(delta: float) -> void:
	var speed: float = 400.0
	if GameState:
		speed = GameState.current_scroll_speed
	
	# Mover TODA la escena hacia la izquierda
	position.x -= speed * delta
	
	# Si la escena entera salió de pantalla, no hacer nada
	# Los obstáculos individuales muy lejanos pueden liberarse


func _on_obstacle_hit(body: Node2D, _obstacle: Node) -> void:
	if body is Player:
		body.die()


## Retorna el último obstáculo (más a la derecha) para calcular fin de nivel
func get_last_x() -> float:
	var max_x: float = 0.0
	for child in get_children():
		if child is Area2D or child is StaticBody2D:
			max_x = max(max_x, child.position.x)
	return max_x
