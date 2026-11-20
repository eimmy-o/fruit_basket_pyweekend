# Fruit Basket

Videojuego 2D estilo arcade hecho en **Godot 4** para taller de principiantes. Mueve la canasta de izquierda a derecha para atrapar la mayor cantidad de frutas posible y esquivar las bombas.

## Objetivo

- **Modo infinito (arcade):** Atrapa tantas frutas como puedas para superar tu **Récord** (se guarda automáticamente).
- **Vidas:** Comienzas con **5 vidas**; cada bomba que toques te resta 1 vida.
- **Dificultad progresiva:** Con cada fruta atrapada, los objetos caen más rápido y aparecen con mayor frecuencia.

## Controles

- **Flecha Izquierda / Flecha Derecha** (o teclas **A / D**): Mover la canasta horizontalmente.
- **Botón Reiniciar**: Volver a jugar al terminar la partida.

## Exportación a Web (GitHub Pages)

El proyecto incluye el preset `Web` en `export_presets.cfg` configurado en modo *Single-Threaded* (`variant/thread_support=false`) apuntando a `docs/index.html` para publicar directamente desde la carpeta `/docs` de la rama `main` en GitHub Pages.
