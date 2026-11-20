extends Node2D

# Escenas que se instanciarán automáticamente (se asignan desde el Inspector)
@export var escena_fruta: PackedScene
@export var escena_bomba: PackedScene

# Probabilidad de que aparezca una bomba (0.3 = 30% bombas, 70% frutas)
@export_range(0.0, 1.0) var probabilidad_bomba: float = 0.3


func _on_spawn_timer_timeout() -> void:
	# Elegimos aleatoriamente si crear una bomba o una fruta
	var escena_elegida: PackedScene
	if randf() < probabilidad_bomba:
		escena_elegida = escena_bomba
	else:
		escena_elegida = escena_fruta

	# Evitamos errores si aún no se asignó la escena en el Inspector
	if escena_elegida == null:
		return

	# Creamos la instancia del objeto y la ubicamos arriba de la pantalla en una X aleatoria
	var objeto = escena_elegida.instantiate()
	objeto.position = Vector2(randf_range(50.0, 750.0), -30.0)

	# Conectamos la señal personalizada del objeto para saber cuando el jugador lo atrapa
	objeto.atrapado.connect(_on_objeto_atrapado)

	# Agregamos el objeto a la escena principal
	add_child(objeto)


func _on_objeto_atrapado(tipo: String) -> void:
	# Por ahora solo mostramos un mensaje en la consola para comprobar que la señal funciona
	if tipo == "fruta":
		print("¡Atrapaste una fruta!")
	else:
		print("¡Tocaste una bomba!")
