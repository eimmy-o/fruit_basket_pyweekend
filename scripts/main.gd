extends Node2D

# Ruta del archivo donde se guarda el puntaje máximo (funciona en PC y navegador)
const RUTA_RECORD := "user://record.save"

# Escenas que se instanciarán automáticamente (se asignan desde el Inspector)
@export var escena_fruta: PackedScene
@export var escena_bomba: PackedScene

# Probabilidad de que aparezca una bomba (0.3 = 30% bombas, 70% frutas)
@export_range(0.0, 1.0) var probabilidad_bomba: float = 0.3

# Reglas base del juego (ajustables desde el Inspector)
@export var vidas_iniciales: int = 5
@export var tiempo_entre_objetos: float = 1.0

# Dificultad progresiva: los objetos caen más rápido y aparecen con mayor frecuencia
@export var incremento_velocidad: float = 15.0
@export var velocidad_extra_maxima: float = 400.0
@export var reduccion_tiempo_spawn: float = 0.02
@export var tiempo_spawn_minimo: float = 0.35

# Variables de estado de la partida actual
var puntaje: int = 0
var puntaje_maximo: int = 0
var vidas: int = 5

# Referencias a los nodos de la interfaz y al temporizador
@onready var puntaje_label: Label = $UI/PuntajeLabel
@onready var vidas_label: Label = $UI/VidasLabel
@onready var panel_fin_juego: Panel = $UI/PanelFinJuego
@onready var mensaje_label: Label = $UI/PanelFinJuego/VBoxContainer/MensajeLabel
@onready var boton_reiniciar: Button = $UI/PanelFinJuego/VBoxContainer/BotonReiniciar
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	# Cargamos el récord guardado de partidas anteriores
	cargar_record()

	# Configuramos el tiempo inicial entre objetos desde el Inspector
	spawn_timer.wait_time = tiempo_entre_objetos
	spawn_timer.start()

	# Inicializamos las vidas y ocultamos el panel de fin de juego
	vidas = vidas_iniciales
	panel_fin_juego.visible = false

	# Mostramos los valores iniciales en la interfaz
	actualizar_ui()

	# Conectamos el botón de reiniciar para poder volver a jugar
	boton_reiniciar.pressed.connect(_on_boton_reiniciar_pressed)


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

	# Aumentamos la velocidad de caída según el puntaje actual (con un tope máximo)
	objeto.velocidad_caida += min(puntaje * incremento_velocidad, velocidad_extra_maxima)

	# Conectamos la señal personalizada del objeto para saber cuando el jugador lo atrapa
	objeto.atrapado.connect(_on_objeto_atrapado)

	# Agregamos el objeto a la escena principal
	add_child(objeto)


func _on_objeto_atrapado(tipo: String) -> void:
	if tipo == "fruta":
		puntaje += 1
		if puntaje > puntaje_maximo:
			puntaje_maximo = puntaje

		# Reducimos poco a poco el tiempo entre objetos hasta el mínimo jugable
		spawn_timer.wait_time = max(
			tiempo_spawn_minimo,
			tiempo_entre_objetos - puntaje * reduccion_tiempo_spawn
		)
		actualizar_ui()
	elif tipo == "bomba":
		vidas -= 1
		actualizar_ui()
		if vidas <= 0:
			terminar_juego()


func actualizar_ui() -> void:
	# Actualizamos los textos de puntaje, récord y vidas en pantalla
	puntaje_label.text = "Puntos: %d  |  Récord: %d" % [puntaje, puntaje_maximo]
	vidas_label.text = "Vidas: %d" % vidas


func terminar_juego() -> void:
	# Guardamos el récord actual antes de pausar el juego
	guardar_record()

	# Detenemos la aparición de objetos y pausamos la escena
	spawn_timer.stop()
	get_tree().paused = true

	# Mostramos el resumen final con puntos y récord
	mensaje_label.text = "¡Game Over!\nPuntos: %d\nRécord: %d" % [puntaje, puntaje_maximo]
	panel_fin_juego.visible = true


func cargar_record() -> void:
	# Leemos el puntaje máximo guardado si el archivo ya existe
	var config := ConfigFile.new()
	if config.load(RUTA_RECORD) == OK:
		puntaje_maximo = config.get_value("record", "puntaje_maximo", 0)


func guardar_record() -> void:
	# Guardamos el puntaje máximo para conservarlo entre partidas
	var config := ConfigFile.new()
	config.set_value("record", "puntaje_maximo", puntaje_maximo)
	config.save(RUTA_RECORD)


func _on_boton_reiniciar_pressed() -> void:
	# Quitamos la pausa antes de recargar la escena para que el nuevo juego arranque activo
	get_tree().paused = false
	get_tree().reload_current_scene()
