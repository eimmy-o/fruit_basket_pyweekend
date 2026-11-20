extends CharacterBody2D

# Velocidad horizontal en píxeles por segundo (ajustable desde el Inspector)
@export var velocidad: float = 400.0


func _physics_process(_delta: float) -> void:
	# Obtenemos la dirección horizontal (-1 izquierda, 0 quieto, 1 derecha)
	# Funciona con las flechas del teclado y también con las teclas A y D
	var direccion := Input.get_axis("ui_left", "ui_right")
	if direccion == 0.0:
		if Input.is_key_pressed(KEY_A):
			direccion = -1.0
		elif Input.is_key_pressed(KEY_D):
			direccion = 1.0

	# Aplicamos movimiento únicamente en el eje X
	velocity.x = direccion * velocidad
	velocity.y = 0.0

	# Ejecutamos el movimiento físico del CharacterBody2D
	move_and_slide()

	# Limitamos la posición en X para que la canasta no salga de la pantalla
	var ancho_pantalla := get_viewport_rect().size.x
	var mitad_ancho := 0.0
	if $Sprite2D.texture:
		mitad_ancho = ($Sprite2D.texture.get_width() * abs($Sprite2D.scale.x)) / 2.0

	position.x = clamp(position.x, mitad_ancho, ancho_pantalla - mitad_ancho)
