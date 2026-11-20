extends Node2D

# Escenas que se instanciarán automáticamente (se asignan desde el Inspector)
@export var escena_fruta: PackedScene
@export var escena_bomba: PackedScene

# Probabilidad de que aparezca una bomba (0.3 = 30% bombas, 70% frutas)
@export_range(0.0, 1.0) var probabilidad_bomba: float = 0.3

# Reglas del juego (ajustables desde el Inspector)
@export var puntaje_meta: int = 10
@export var vidas_iniciales: int = 3
@export var tiempo_entre_objetos: float = 1.0

# Variables de estado de la partida actual
var puntaje: int = 0
var vidas: int = 3

# Referencias a los nodos de la interfaz y al temporizador
@onready var puntaje_label: Label = $UI/PuntajeLabel
@onready var vidas_label: Label = $UI/VidasLabel
@onready var panel_fin_juego: Panel = $UI/PanelFinJuego
@onready var mensaje_label: Label = $UI/PanelFinJuego/VBoxContainer/MensajeLabel
@onready var boton_reiniciar: Button = $UI/PanelFinJuego/VBoxContainer/BotonReiniciar
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	# Configuramos el tiempo entre cada objeto que cae desde el Inspector
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

	# Conectamos la señal personalizada del objeto para saber cuando el jugador lo atrapa
	objeto.atrapado.connect(_on_objeto_atrapado)

	# Agregamos el objeto a la escena principal
	add_child(objeto)


func _on_objeto_atrapado(tipo: String) -> void:
	if tipo == "fruta":
		puntaje += 1
		actualizar_ui()
		if puntaje >= puntaje_meta:
			terminar_juego(true)
	elif tipo == "bomba":
		vidas -= 1
		actualizar_ui()
		if vidas <= 0:
			terminar_juego(false)


func actualizar_ui() -> void:
	# Actualizamos los textos de puntaje y vidas en pantalla
	puntaje_label.text = "Puntos: %d / %d" % [puntaje, puntaje_meta]
	vidas_label.text = "Vidas: %d" % vidas


func terminar_juego(gano: bool) -> void:
	# Detenemos la aparición de objetos y pausamos el juego
	spawn_timer.stop()
	get_tree().paused = true

	# Mostramos el mensaje correspondiente y el panel final
	if gano:
		mensaje_label.text = "¡Ganaste!"
	else:
		mensaje_label.text = "¡Game Over!"
	panel_fin_juego.visible = true


func _on_boton_reiniciar_pressed() -> void:
	# Quitamos la pausa antes de recargar la escena para que el nuevo juego arranque activo
	get_tree().paused = false
	get_tree().reload_current_scene()
