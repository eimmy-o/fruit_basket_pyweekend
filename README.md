# Fruit Basket

Videojuego 2D sencillo hecho en **Godot 4** para taller de principiantes. Mueve la canasta de izquierda a derecha para atrapar las frutas que caen y esquivar las bombas.

## Objetivo

- **Ganar:** Atrapa **10 frutas**.
- **Perder:** Comienzas con **3 vidas**; cada bomba que toques te resta 1 vida. Si llegas a 0, termina la partida.

## Controles

- **Flecha Izquierda / Flecha Derecha** (o teclas **A / D**): Mover la canasta horizontalmente.
- **Botón Reiniciar**: Volver a jugar al terminar la partida.

## Exportación a Web (GitHub Pages)

El proyecto incluye el preset `Web` en `export_presets.cfg` configurado en modo *Single-Threaded* (`variant/thread_support=false`) apuntando a `docs/index.html` para publicar directamente desde la carpeta `/docs` de la rama `main` en GitHub Pages.
