extends Area2D

# Velocidad de caída en píxeles por segundo (ajustable desde el Inspector)
@export var velocidad_caida: float = 200.0

# Tipo de objeto para diferenciar frutas de bombas desde el Inspector
@export_enum("fruta", "bomba") var tipo: String = "fruta"


func _process(delta: float) -> void:
	# Movemos el objeto hacia abajo de forma constante en cada fotograma
	position.y += velocidad_caida * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Eliminamos el objeto cuando sale de la pantalla para evitar fugas de memoria
	queue_free()
