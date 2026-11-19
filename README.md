# # Alien Invasion

## 1. Descripción del proyecto

Alien Invasion es un videojuego desarrollado en C# utilizando el framework MonoGame. El proyecto consiste en un juego de estilo Space Invaders en el que el jugador debe controlar una nave espacial, eliminar enemigos y evitar sus disparos.

El objetivo es sobrevivir y conseguir la mayor cantidad de puntos posible.

## 2. Tecnologías utilizadas

- **Lenguaje:** C#
- **Framework:** MonoGame
- **Base de datos:** MySQL
- **Conexión con la base de datos:** MySqlConnector
- **Entorno de desarrollo:** Visual Studio Code
- **Servidor local:** XAMPP

## 3. Mecánicas del juego

El juego cuenta con las siguientes características:

- Movimiento de la nave mediante las teclas A y D o las flechas izquierda y derecha.
- Disparos del jugador mediante la barra espaciadora.
- Enemigos con diferentes cantidades de vida y puntos otorgados.
- Disparos realizados por los enemigos.
- Obstáculos que pueden recibir daño.
- Sistema de vidas.
- Sistema de puntuación.
- Pantalla de Game Over.
- Condición de victoria al eliminar todos los enemigos.

## 4. Base de datos

El proyecto utiliza una base de datos MySQL llamada `Alien_Invasion`.

Entre sus principales tablas se encuentran:

- `Players`: almacena los jugadores.
- `Naves`: contiene los datos de las naves disponibles.
- `NavesPlayers`: relaciona los jugadores con las naves elegidas.
- `Sessions`: registra las partidas realizadas.
- `RegistrosNiveles`: almacena los resultados de cada partida.
- `AliensTypes`: contiene los tipos de enemigos.
- `Niveles`: almacena la información de los niveles.

La conexión entre C# y MySQL se realiza mediante la biblioteca MySqlConnector.

### Registro de partidas

Cuando comienza una partida, el programa busca al jugador en la tabla `Players`. Si no existe, lo registra.

Luego crea una nueva sesión en `Sessions`.

Al finalizar la partida, se guarda:
- Fecha de finalización.
- Estado final (Victoria o Derrota).
- Tiempo jugado.
- Enemigos eliminados.
- Puntaje obtenido.

Los resultados se almacenan en `RegistrosNiveles`.

## 5. Estructura del proyecto

Principales clases del proyecto:

- `Game1.cs`: controla el funcionamiento general del juego.
- `Menu.cs`: administra el menú inicial y la selección de nave.
- `AlienEnemigo.cs`: representa a los enemigos y administra su vida.
- `Obstaculo.cs`: representa los obstáculos del escenario.
- `BaseDatos.cs`: contiene las operaciones de conexión y consultas a MySQL.
- `PilaManual.cs`: implementación de la estructura de datos manual.

## 6. Estructuras de datos y algoritmos

En esta sección se debe documentar la estructura de datos manual implementada sobre arrays y el algoritmo clásico seleccionado para el proyecto.

**Estructura de datos:** completar con la estructura utilizada (Pila o Cola Circular), sus operaciones y dónde se utiliza en el juego.

**Algoritmo:** completar con el algoritmo seleccionado (Ordenamiento por Burbuja o Búsqueda Secuencial), su funcionamiento y dónde se aplica.

## 7. Persistencia de datos

El proyecto utiliza MySQL para almacenar los jugadores, las partidas y sus resultados.

También se deben documentar los archivos `.conf` o `.dat` utilizados para guardar la configuración y los puntajes locales del juego.

**Pendiente de completar:** indicar los nombres de los archivos locales y qué información almacena cada uno.

## 8. Pruebas funcionales

Se realizan pruebas manuales para comprobar el funcionamiento del juego:

- Inicio de una partida.
- Movimiento de la nave.
- Disparos del jugador.
- Disparos de los enemigos.
- Colisiones entre disparos y enemigos.
- Pérdida de vidas.
- Destrucción de obstáculos.
- Actualización del puntaje.
- Victoria al eliminar todos los enemigos.
- Derrota al quedarse sin vidas.
- Registro de jugadores y partidas en MySQL.

## 9. Manejo de errores

Se utiliza `try-catch` para controlar posibles excepciones durante las operaciones que pueden producir errores, especialmente las conexiones y consultas a la base de datos.

## 10. Ejecución del proyecto

1. Instalar .NET y MonoGame.
2. Instalar y configurar MySQL mediante XAMPP.
3. Importar el archivo SQL `Alien_Invasion.sql`.
4. Verificar los datos de conexión en `BaseDatos.cs`.
5. Abrir el proyecto en Visual Studio Code.
6. Ejecutar el proyecto.

---

**Proyecto interdisciplinario de Algoritmos y Estructuras de Datos y Base de Datos.**
