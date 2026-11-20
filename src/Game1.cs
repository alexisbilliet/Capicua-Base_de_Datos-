
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System.Collections.Generic;
using System;
namespace Project2
{
    public struct Disparo
    {
        public Rectangle Rectangulo;
        public int Velocidad;

        public Disparo(int x, int y)
        {
            Rectangulo = new Rectangle(x, y, 6, 16);
            Velocidad = 12;
        }
    }

    public class Game1 : Game
    {
        
        private bool victoria;
        private int idJugador;
        private int idSession;
        private DateTime fechaInicio;
        private int enemigosEliminados;
        private bool resultadoGuardado;
        private Vector2 posicion;
        private float velocidad = 200f;
        private Texture2D spriteNave;
        private List<Obstaculo> obstaculos = new List<Obstaculo>();

        private Texture2D pixel;
        private SpriteFont fuente;

        private int vidas = 3;
        private int puntaje = 0;

        private Texture2D alien1;
        private Texture2D alien2;
        private Texture2D alien3;

        private List<DatosAlien> tiposAliens = new List<DatosAlien>();

        private int dano = 10;
        private List<AlienEnemigo> listaAliens = new List<AlienEnemigo>();
        private List<Disparo> listaDisparos = new List<Disparo>();
        private List<Disparo> disparosAliens = new List<Disparo>();

        private float tiempoDisparoAlien = 0f;
        private float intervaloDisparoAlien = 0.8f;
        private int indiceAlienDisparador = 0;
        private KeyboardState teclaActual;
        private KeyboardState teclaAnterior;

        private GraphicsDeviceManager _graphics;
        private SpriteBatch _spriteBatch;

        // Menu
        private Menu menu;
        private bool partidaIniciada = false;
        private bool gameOver = false;

        public Game1()
        {
            _graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = true;

            _graphics.PreferredBackBufferWidth = 1024;
            _graphics.PreferredBackBufferHeight = 1024;
            _graphics.ApplyChanges();
        }

        protected override void LoadContent()
{
    _spriteBatch = new SpriteBatch(GraphicsDevice);

    posicion = new Vector2(500, 950);

    alien1 = Content.Load<Texture2D>("alien1");
    alien2 = Content.Load<Texture2D>("alien2");
    alien3 = Content.Load<Texture2D>("alien3");

    // Cargar los tipos de aliens desde MySQL
    tiposAliens = BaseDatos.CargarTiposAliens();

    fuente = Content.Load<SpriteFont>("Arial");

    pixel = new Texture2D(GraphicsDevice, 1, 1);
    pixel.SetData(new[] { Color.White });

    // Crear aliens y obstaculos
    ReiniciarAliens();
    ReiniciarObstaculos();

    // Crear el menu
    menu = new Menu(Window, fuente, pixel);
}
        protected override void Update(GameTime gameTime)
        {
            teclaActual = Keyboard.GetState();

            if (!partidaIniciada)
            {
                menu.Actualizar();

                if (menu.SolicitaSalir)
                {
                    Exit();
                }

                if (menu.InicioSolicitado)
                {
                    ComenzarPartida();
                }
            }
            else
            {
                if (teclaActual.IsKeyDown(Keys.Escape) &&
                    teclaAnterior.IsKeyUp(Keys.Escape))
                {
                    Exit();
                }

                if (!gameOver)
        {
            ActualizarPartida(gameTime);
        }
        else
{
    if (teclaActual.IsKeyDown(Keys.Enter) &&
        teclaAnterior.IsKeyUp(Keys.Enter))
    {
        partidaIniciada = false;
        gameOver = false;

        menu.VolverAlMenu();
    }
}
            }

            teclaAnterior = teclaActual;

            base.Update(gameTime);
        }

        private void ComenzarPartida()
{
    idJugador = BaseDatos.ObtenerOCrearJugador(menu.NombreJugador);

    idSession = BaseDatos.CrearSession(idJugador);

    fechaInicio = DateTime.Now;
    enemigosEliminados = 0;
    resultadoGuardado = false;
    DatosNave nave = menu.NaveElegida;

    spriteNave = Content.Load<Texture2D>(nave.Nombre);

    vidas = nave.Vida;
    velocidad = nave.Velocidad;
    dano = nave.Dano;
    puntaje = 0;

    listaDisparos.Clear();
    disparosAliens.Clear();

    tiempoDisparoAlien = 0f;
    indiceAlienDisparador = 0;

    posicion = new Vector2(500, 950);

    ReiniciarAliens();
    ReiniciarObstaculos();

    gameOver = false;
    partidaIniciada = true;
}
       



private void DispararAlien()
{
    int cantidad = listaAliens.Count;

    if (cantidad == 0)
        return;

    // Contar las columnas que tienen un alien habilitado
    int total = 0;

    foreach (AlienEnemigo al in listaAliens)
    {
        if (!al.Activo)
            continue;

        bool tieneAlienDebajo = false;

        foreach (AlienEnemigo otro in listaAliens)
        {
            if (otro.Activo &&
                otro.Hitbox.X == al.Hitbox.X &&
                otro.Hitbox.Y > al.Hitbox.Y)
            {
                tieneAlienDebajo = true;
                break;
            }
        }

        if (!tieneAlienDebajo)
            total++;
    }

    if (total == 0)
        return;

    // Elegir un alien habilitado según el turno
    int elegido = indiceAlienDisparador % total;
    int contador = 0;

    foreach (AlienEnemigo al in listaAliens)
    {
        if (!al.Activo)
            continue;

        bool tieneAlienDebajo = false;

        foreach (AlienEnemigo otro in listaAliens)
        {
            if (otro.Activo &&
                otro.Hitbox.X == al.Hitbox.X &&
                otro.Hitbox.Y > al.Hitbox.Y)
            {
                tieneAlienDebajo = true;
                break;
            }
        }

        if (!tieneAlienDebajo)
        {
            if (contador == elegido)
            {
                int x = al.Hitbox.X + (al.Hitbox.Width / 2) - 3;
                int y = al.Hitbox.Bottom;

                Disparo disparo = new Disparo(x, y);
                disparo.Velocidad = 6;

                disparosAliens.Add(disparo);
                break;
            }

            contador++;
        }
    }

    indiceAlienDisparador++;

    if (indiceAlienDisparador >= total)
        indiceAlienDisparador = 0;
}



        // ---------------- JUEGO ----------------

        private void ActualizarPartida(GameTime gameTime)
        {
           
            float tiempo =
                (float)gameTime.ElapsedGameTime.TotalSeconds;

            // Movimiento de la nave
            if (teclaActual.IsKeyDown(Keys.Right) ||
                teclaActual.IsKeyDown(Keys.D))
            {
                posicion.X += velocidad * tiempo;
            }

            if (teclaActual.IsKeyDown(Keys.Left) ||
                teclaActual.IsKeyDown(Keys.A))
            {
                posicion.X -= velocidad * tiempo;
            }

            posicion.X = MathHelper.Clamp(
                posicion.X,
                0,
                GraphicsDevice.Viewport.Width - spriteNave.Width
            );

            // Disparar
            if (teclaActual.IsKeyDown(Keys.Space) &&
                teclaAnterior.IsKeyUp(Keys.Space))
            {
                int xBalas =
                    (int)posicion.X + (spriteNave.Width / 2) - 3;

                int yBalas = (int)posicion.Y;

                listaDisparos.Add(new Disparo(xBalas, yBalas));
            }

            // Movimiento de las balas
            for (int i = 0; i < listaDisparos.Count; i++)
            {
                Disparo d = listaDisparos[i];

                d.Rectangulo.Y -= d.Velocidad;
                listaDisparos[i] = d;

                if (d.Rectangulo.Y + d.Rectangulo.Height < 0)
                {
                    listaDisparos.RemoveAt(i);
                    i--;
                }
            }

            
        // Colisiones con aliens
        for (int i = 0; i < listaDisparos.Count; i++)
        {
            Disparo d = listaDisparos[i];

            for (int k = 0; k < listaAliens.Count; k++)
            {
                AlienEnemigo al = listaAliens[k];

                if (!al.Activo)
                    continue;

                if (d.Rectangulo.Intersects(al.Hitbox))
                {
                    bool eliminado = al.RecibirDano(dano);

                    listaAliens[k] = al;

                    if (eliminado)
                    {
                        puntaje += al.Puntos;
                        enemigosEliminados++;
                    }

                    listaDisparos.RemoveAt(i);
                    i--;

                    break;
                }
            }
        }
        // Tiempo entre disparos de los aliens
        tiempoDisparoAlien += tiempo;

        if (tiempoDisparoAlien >= intervaloDisparoAlien)
        {
            DispararAlien();
            tiempoDisparoAlien = 0f;
        }       

        // Movimiento de los disparos enemigos
        for (int i = 0; i < disparosAliens.Count; i++)
        {
            Disparo d = disparosAliens[i];

            d.Rectangulo.Y += d.Velocidad;
            disparosAliens[i] = d;

            // Eliminar si sale de la pantalla
            if (d.Rectangulo.Y > GraphicsDevice.Viewport.Height)
            {
             disparosAliens.RemoveAt(i);
                i--;
                continue;
            }
        // Colision con obstaculos
        bool impactoObstaculo = false;

        for (int j = 0; j < obstaculos.Count; j++)
        {
            if (obstaculos[j].Activo &&
                d.Rectangulo.Intersects(obstaculos[j].Area))
            {
                obstaculos[j].RecibirDano();
                impactoObstaculo = true;
                break;
            }
        }

        if (impactoObstaculo)
        {
            disparosAliens.RemoveAt(i);
            i--;
            continue;
        }
            // Colision con el jugador
            Rectangle hitboxJugador = new Rectangle(
                (int)posicion.X,
                (int)posicion.Y,
                spriteNave.Width,
                spriteNave.Height
            );

            if (d.Rectangulo.Intersects(hitboxJugador))
            {
                vidas--;

                disparosAliens.RemoveAt(i);
                i--;
            }
        }
        // comrpobar si se perdio o se gano
        int aliensVivos = 0;
        if (vidas <= 0){
            if (!resultadoGuardado)
            {
                TimeSpan tiempoPartida = DateTime.Now - fechaInicio;

                BaseDatos.GuardarResultado(
                    idSession,
                    puntaje,
                    enemigosEliminados,
                    tiempoPartida,
                    "Derrota"
                );

                resultadoGuardado = true;
            }

            victoria = false;
            gameOver = true;
            return;
        }       
        foreach (AlienEnemigo al in listaAliens)
        {
            if (al.Activo)
            {
                aliensVivos++;
            }
}       

        if (aliensVivos == 0)
        {
            if (!resultadoGuardado)
            {
                TimeSpan tiempoPartida = DateTime.Now - fechaInicio;

                BaseDatos.GuardarResultado(
                    idSession,
                    puntaje,
                 enemigosEliminados,
                    tiempoPartida,
                    "Victoria"
                );

                resultadoGuardado = true;
            }

            victoria = true;
            gameOver  =true;
            return;
        }       
    }

        // ---------------- DIBUJAR ----------------

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(new Color(10, 20, 40));

            _spriteBatch.Begin();

            if (!partidaIniciada)
            {
                menu.Dibujar(_spriteBatch);
            }
            else
            {
                if (!gameOver)
        {
            DibujarPartida();
        }
        else
        {
            DibujarGameOver();
        }
            }

            _spriteBatch.End();

            base.Draw(gameTime);
        }

        private void DibujarPartida()
        {
           _spriteBatch.Draw(spriteNave, posicion, Color.White);

            
        foreach (AlienEnemigo al in listaAliens)
        {
            if (al.Activo)
            {
                Texture2D sprite;

                if (al.Nombre == "Alien 1")
                    sprite = alien1;
                else if (al.Nombre == "Alien 2")
                    sprite = alien2;
                else
                    sprite = alien3;

                _spriteBatch.Draw(
                    sprite,
                    al.Posicion,
                    Color.White
             );
            }
        }


            foreach (Disparo disparo in listaDisparos)
            {
                _spriteBatch.Draw(
                    pixel,
                    disparo.Rectangulo,
                    Color.Cyan
                );
            }

            _spriteBatch.DrawString(
                fuente,
                "Jugador: " + menu.NombreJugador,
                new Vector2(10, 70),
                Color.White
            );

            _spriteBatch.DrawString(
                fuente,
                "Vidas: " + vidas,
                new Vector2(10, 10),
                Color.White
            );

            _spriteBatch.DrawString(
                fuente,
                "Puntaje: " + puntaje,
                new Vector2(10, 40),
                Color.Yellow
            );
        foreach (Disparo disparo in disparosAliens)
        {
            _spriteBatch.Draw(
                pixel,
                disparo.Rectangulo,
                Color.Red
            );
        }
            foreach (Obstaculo obstaculo in obstaculos)
            {
                if (obstaculo.Activo)
                {
                    _spriteBatch.Draw(
                        pixel,
                        obstaculo.Area,
                        Color.Red
                    );
                }
            }
        }
        private void DibujarGameOver()
{
    string titulo;

if (victoria)
{
    titulo = "VICTORIA";
}
else
{
    titulo = "GAME OVER";
}
    string resultado = "Puntaje final: " + puntaje;
    string mensaje = "Presiona ENTER para volver al menu";

    Vector2 medidaTitulo = fuente.MeasureString(titulo);
    Vector2 medidaResultado = fuente.MeasureString(resultado);
    Vector2 medidaMensaje = fuente.MeasureString(mensaje);

    float centroX = GraphicsDevice.Viewport.Width / 2f;
    float centroY = GraphicsDevice.Viewport.Height / 2f;

    _spriteBatch.DrawString(
        fuente,
        titulo,
        new Vector2(centroX - medidaTitulo.X / 2, centroY - 100),
        Color.Red
    );

    _spriteBatch.DrawString(
        fuente,
        resultado,
        new Vector2(centroX - medidaResultado.X / 2, centroY - 20),
        Color.White
    );

    _spriteBatch.DrawString(
        fuente,
        mensaje,
        new Vector2(centroX - medidaMensaje.X / 2, centroY + 50),
        Color.Yellow
    );
}
private void ReiniciarAliens()
{
    listaAliens.Clear();

    DatosAlien tipo1 = tiposAliens.Find(a => a.Nombre == "Alien 1");
    DatosAlien tipo2 = tiposAliens.Find(a => a.Nombre == "Alien 2");
    DatosAlien tipo3 = tiposAliens.Find(a => a.Nombre == "Alien 3");

    for (int x = 0; x < 6; x++)
    {
        for (int i = 0; i < 9; i++)
        {
            Vector2 posInicial =
                new Vector2(80 + (i * 100), 100 + (x * 100));

            DatosAlien tipoElegido;
            Texture2D spriteElegido;

            if (x < 2)
            {
                tipoElegido = tipo3;
                spriteElegido = alien3;
            }
            else if (x < 4)
            {
                tipoElegido = tipo2;
                spriteElegido = alien2;
            }
            else
            {
                tipoElegido = tipo1;
                spriteElegido = alien1;
            }

            listaAliens.Add(
                new AlienEnemigo(
                    posInicial,
                    spriteElegido.Width,
                    spriteElegido.Height,
                    tipoElegido
                )
            );
        }
    }
}
private void ReiniciarObstaculos()
{
    obstaculos.Clear();

    obstaculos.Add(new Obstaculo(181, 850, 100, 30));
    obstaculos.Add(new Obstaculo(462, 850, 100, 30));
    obstaculos.Add(new Obstaculo(743, 850, 100, 30));
}
    }
    
}
