# Alien Invasion

## 1. Descripción del proyecto

Alien Invasion es un videojuego desarrollado en C# utilizando el framework MonoGame. El proyecto consiste en un juego de estilo Space Invaders en el que el jugador elige una nave, elimina enemigos y evita sus disparos mientras sube de nivel y mejora sus estadísticas.

El objetivo es eliminar a todos los enemigos y conseguir la mayor cantidad de puntos posible.

## 2. Tecnologías utilizadas

- **Lenguaje:** C#
- **Framework:** MonoGame
- **Base de datos:** MySQL
- **Conexión con la base de datos:** MySqlConnector
- **Entorno de desarrollo:** Visual Studio Code
- **Servidor local:** XAMPP

## 3. Controles

| Acción | Tecla |
|---|---|
| Mover la nave | A / D o flechas izquierda / derecha |
| Disparar | Barra espaciadora (mantenida, respeta la cadencia de la nave) |
| Escribir el nombre | Teclado |
| Continuar / Jugar | Enter o clic en el botón |
| Cambiar de nave | Flechas izquierda / derecha o clic en la tarjeta |
| Volver / Salir | Escape |
| Volver al menú desde Game Over o Victoria | Enter |

## 4. Mecánicas del juego

- **Menú inicial** con el logo, el ingreso del nombre del jugador y el ranking.
- **Selección de nave:** el jugador elige entre tres naves, cada una con sus estadísticas (vida, daño, velocidad y cadencia) leídas desde la base de datos. Las tarjetas muestran el sprite de cada nave.
- **Movimiento** de la nave a izquierda y derecha, limitado a los bordes de la pantalla.
- **Disparos del jugador** con tiempo de espera entre disparo y disparo según la cadencia de la nave (`Cadencia` = segundos entre disparos).
- **Enemigos** de tres tipos, con distinta vida y puntos otorgados. Están ordenados en una grilla de 6 filas por 9 columnas.
- **Disparos enemigos:** en cada intervalo dispara un alien elegido al azar entre los que no tienen otro alien debajo.
- **Obstáculos** que reciben daño de los disparos enemigos y se destruyen tras varios impactos.
- **Sistema de vidas** y **sistema de puntuación**.
- **Sistema de niveles del jugador** (ver sección 5).
- **Pantalla de Game Over** y **pantalla de Victoria** al eliminar todos los enemigos.
- **Ranking** con los mejores jugadores, visible en el menú inicial (se muestran las primeras 9 posiciones).

## 5. Sistema de niveles del jugador

Los niveles se cargan desde la tabla `Niveles` al iniciar el juego y se ordenan por `IDNivel`.

- El jugador comienza en el primer nivel.
- Cuando su puntaje alcanza el valor `PuntosNecesarios` del nivel siguiente, sube de nivel. Aparece un aviso en pantalla y el HUD muestra el nivel actual.
- Cada nivel aplica multiplicadores sobre las estadísticas **base** de la nave elegida (no se acumulan entre niveles):

| Columna | Efecto |
|---|---|
| `MultiDano` | Multiplica el daño de los disparos del jugador |
| `MultiVel` | Multiplica la velocidad de movimiento de la nave |
| `Multivida` | Multiplica la vida máxima. Al subir de nivel se suma la diferencia a las vidas actuales, sin curar de golpe |

- Al subir de nivel se guarda un registro del nivel terminado en `RegistrosNiveles`.

## 6. Base de datos

El proyecto utiliza la base de datos MySQL llamada `Alien_Invasion`.

Tablas que utiliza el juego:

- `Players`: almacena los jugadores.
- `Naves`: contiene los datos de las naves disponibles.
- `NavesPlayers`: relaciona los jugadores con las naves elegidas.
- `Sessions`: registra las partidas realizadas.
- `Niveles`: define los niveles del jugador, sus multiplicadores y los puntos necesarios.
- `RegistrosNiveles`: almacena los resultados de cada nivel jugado dentro de una partida.
- `AliensTypes`: contiene los tipos de enemigos.


La conexión entre C# y MySQL se realiza mediante la biblioteca MySqlConnector, con consultas parametrizadas.

### Datos que debe tener la base para jugar

- `Naves`: **exactamente tres naves**. El nombre de cada una debe coincidir con el nombre del sprite cargado en `Content`.
- `AliensTypes`: tres tipos llamados `Alien 1`, `Alien 2` y `Alien 3`.
- `Niveles`: al menos un nivel, con todas sus columnas completas. Si la tabla está vacía, el juego usa un nivel base con multiplicadores en 1 y `IDNivel` 1.

### Registro de partidas

Cuando comienza una partida, el programa busca al jugador en la tabla `Players`. Si no existe, lo registra. Luego crea una nueva sesión en `Sessions`.

Durante la partida, cada vez que el jugador termina un nivel (por subir de nivel, ganar o perder) se inserta una fila en `RegistrosNiveles` con:

- Nivel (`IDNivel`).
- Tiempo invertido en ese nivel.
- Enemigos eliminados en ese nivel.
- Puntaje obtenido en ese nivel.

Al finalizar la partida, en `Sessions` se guarda la fecha de finalización y el estado final (Victoria o Derrota).

### Ranking

La consulta suma el puntaje de todos los registros de cada jugador (`sum(PuntajeTotal)`), por lo que el ranking refleja el puntaje acumulado en todas sus partidas.

## 7. Estructura del proyecto

Principales clases del proyecto:

- `Game1.cs`: controla el funcionamiento general del juego, los niveles y la lógica de la partida.
- `Menu.cs`: administra el menú inicial, la selección de nave y el dibujo del ranking.
- `Ranking.cs`: carga el ranking desde la base y lo ordena con el algoritmo de burbuja.
- `AlienEnemigo.cs`: representa a los enemigos y administra su vida.
- `Obstaculo.cs`: representa los obstáculos del escenario.
- `BaseDatos.cs`: contiene las operaciones de conexión y consultas a MySQL, junto con las clases de datos (`DatosNave`, `DatosAlien`, `DatosRanking`, `DatosNivel`).

## 8. Estructuras de datos y algoritmos

### Estructura de datos


### Algoritmo: ordenamiento por burbuja

Se aplica en `Ranking.Ordenar()` para ordenar a los jugadores por puntaje acumulado, de mayor a menor.

Funcionamiento:

1. Un bucle externo repite el proceso tantas veces como elementos haya menos uno.
2. Un bucle interno recorre la lista comparando cada elemento con el siguiente.
3. Si el puntaje del elemento actual es menor que el del siguiente, se intercambian de lugar con una variable auxiliar.
4. En cada pasada, el menor puntaje "burbujea" hacia el final, y en cada vuelta se recorre un elemento menos porque los últimos ya quedaron ordenados.

Se ejecuta cada vez que se carga el ranking, al abrir el menú y al volver a él después de una partida.


## 9. Recursos gráficos

- Sprites de las naves y de los enemigos: Estilo Kenney.nl 
- Interfaz del menú (logo, paneles, botones y tarjetas de nave): Estilo Kenney.nl 

## 10. Pruebas funcionales

Se realizan pruebas manuales para comprobar el funcionamiento del juego:

- Ingreso de un nombre vacío (debe mostrar un aviso) y de un nombre nuevo o existente.
- Selección de nave con teclado y con mouse.
- Inicio de una partida con cada nave.
- Movimiento de la nave y límites de pantalla.
- Disparos del jugador y respeto de la cadencia.
- Disparos de los enemigos.
- Colisiones entre disparos y enemigos.
- Pérdida de vidas.
- Destrucción de obstáculos.
- Actualización del puntaje.
- Subida de nivel al alcanzar los puntos necesarios y aplicación de los multiplicadores.
- Victoria al eliminar todos los enemigos.
- Derrota al quedarse sin vidas.
- Registro de jugadores, sesiones y niveles en MySQL.
- Actualización del ranking al volver al menú.

## 11. Manejo de errores

Se utiliza `try-catch` en las operaciones que pueden producir errores, especialmente las conexiones y consultas a la base de datos:

- Búsqueda del jugador y carga de naves en el menú.
- Carga del ranking.
- Guardado de la nave elegida.
- Guardado de cada nivel y cierre de la sesión durante la partida. Si falla, el juego no se cierra y se muestra un aviso en la pantalla de Game Over.

## 12. Ejecución del proyecto

1. Instalar .NET y MonoGame.
2. Instalar y configurar MySQL mediante XAMPP.
3. Importar el archivo SQL `Alien_Invasion.sql`.
4. Cargar los datos necesarios en `Naves`, `AliensTypes` y `Niveles` (ver sección 6).
5. Verificar los datos de conexión en `BaseDatos.cs`.
6. Abrir el proyecto en Visual Studio Code.
7. Ejecutar el proyecto.

---

**Proyecto interdisciplinario de Algoritmos y Estructuras de Datos y Base de Datos.**
