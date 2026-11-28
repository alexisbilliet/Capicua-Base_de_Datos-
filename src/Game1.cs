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
        private float cooldownDisparo;
        private float tiempoDesdeDisparo = 0f;

        private bool victoria;
        private int idJugador;
        private int idSession;
        private int enemigosEliminados;
        private bool resultadoGuardado;
        private Vector2 posicion;
        private float velocidad = 200f;
        private Texture2D spriteNave;
        private List<Obstaculo> obstaculos = new List<Obstaculo>();

        // Niveles del jugador (vienen de la tabla Niveles)
        private List<DatosNivel> niveles = new List<DatosNivel>();
        private int nivelActual = 0;
        private DatosNave naveJugador;          // stats base de la nave elegida
        private int vidaMaxima;                 // vida maxima segun el nivel
        private int puntajeInicioNivel;
        private int enemigosInicioNivel;
        private DateTime fechaInicioNivel;
        private float tiempoAvisoNivel = 0f;    // segundos que se muestra "NIVEL X!"
        private string errorBase = "";

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
        private Random azar = new Random();

        private float tiempoDisparoAlien = 0f;
        private float intervaloDisparoAlien = 0.4f;
        // Boss
        private Texture2D spriteBoss;
        private AlienEnemigo boss;
        private int dificultad = 1;
        private float[] multiVidaDificultad = { 1f, 1.5f, 2f };                       //  para cuando se cambia la dificultad
        private float[] multiCadenciaDificultad = { 1f, 1.3f, 1.6f };
        private bool bossAparecio = false;
        private Vector2 bossVelocidad;
        private float tiempoDisparoBoss = 0f;
        private float intervaloDisparoBoss = 0.5f;      // segundos entre disparos del boss
        private const int VELOCIDAD_DISPARO_LENTO = 4;
        private const int VELOCIDAD_DISPARO_RAPIDO = 14;
        private const int VIDA_BOSS = 300;              // se usan si no hay "Alien Boss" en AliensTypes
        private const int PUNTOS_BOSS = 500;
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
            spriteBoss = Content.Load<Texture2D>("alienboss");

            // Cargar los tipos de aliens y los niveles desde MySQL
            tiposAliens = BaseDatos.CargarTiposAliens();
            niveles = BaseDatos.CargarNiveles();


            fuente = Content.Load<SpriteFont>("Arial");

            pixel = new Texture2D(GraphicsDevice, 1, 1);
            pixel.SetData(new[] { Color.White });

            // Crear aliens y obstaculos
            ReiniciarAliens();
            ReiniciarObstaculos();

            // Crear el menu
            menu = new Menu(Window, Content, fuente, pixel);
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
                if (teclaActual.IsKeyDown(Keys.Escape) && teclaAnterior.IsKeyUp(Keys.Escape))
                {
                    Exit();
                }

                if (!gameOver)
                {
                    ActualizarPartida(gameTime);
                }
                else
                {
                    if (teclaActual.IsKeyDown(Keys.Enter) && teclaAnterior.IsKeyUp(Keys.Enter))
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

            enemigosEliminados = 0;
            resultadoGuardado = false;
            errorBase = "";
            tiempoAvisoNivel = 0f;

            naveJugador = menu.NaveElegida;
            dificultad = menu.Dificultad;

            spriteNave = Content.Load<Texture2D>(naveJugador.Nombre);

            // Stats base de la nave; despues el nivel aplica sus multiplicadores
            vidas = naveJugador.Vida;
            vidaMaxima = naveJugador.Vida;
            puntaje = 0;

            if (naveJugador.Cadencia > 0)
            cooldownDisparo = (float)naveJugador.Cadencia;

            tiempoDesdeDisparo = cooldownDisparo;   // puede disparar apenas empieza

            // El jugador empieza en el primer nivel
            nivelActual = 0;
            puntajeInicioNivel = 0;
            enemigosInicioNivel = 0;
            fechaInicioNivel = DateTime.Now;
            AplicarNivel();

            listaDisparos.Clear();
            disparosAliens.Clear();

            tiempoDisparoAlien = 0f;
            bossAparecio = false;
            boss = default(AlienEnemigo);
            posicion = new Vector2(500, 950);

            ReiniciarAliens();
            ReiniciarObstaculos();

            gameOver = false;
            partidaIniciada = true;
        }

        // Aplica los multiplicadores del nivel actual a la nave del jugador.
        // Siempre se calculan sobre los stats base de la nave (no se acumulan).
        private void AplicarNivel()
        {
            DatosNivel nivel = niveles[nivelActual];

            dano = Math.Max(1, (int)Math.Round(naveJugador.Dano * nivel.MultiDano));
            velocidad = naveJugador.Velocidad * nivel.MultiVel;

            // La vida maxima nueva se suma a la vida actual (no cura de golpe)
            int nuevaVidaMaxima = Math.Max(1, (int)Math.Round(naveJugador.Vida * nivel.MultiVida));
            nuevaVidaMaxima = Math.Min(nuevaVidaMaxima, 9);

            vidas += nuevaVidaMaxima - vidaMaxima;
            vidaMaxima = nuevaVidaMaxima;
        }

        // Guarda en RegistrosNiveles lo que paso en el nivel que se termina
        private void GuardarNivelActual()
        {
            try
            {
                TimeSpan tiempoNivel = DateTime.Now - fechaInicioNivel;

                BaseDatos.GuardarRegistroNivel(idSession, niveles[nivelActual].IDNivel, puntaje - puntajeInicioNivel, enemigosEliminados - enemigosInicioNivel, tiempoNivel);
            }
            catch (Exception ex)
            {
                errorBase = "No se pudo guardar el nivel: " + ex.Message;
            }
        }

        // Cierra la sesion en la base ("Victoria" o "Derrota")
        private void FinalizarSesion(string estado)
        {
            try
            {
                BaseDatos.FinalizarSession(idSession, estado);
            }
            catch (Exception ex)
            {
                errorBase = "No se pudo cerrar la sesion: " + ex.Message;
            }
        }

        private void DispararAlien()
        {
            int cantidad = listaAliens.Count;
            int aliensvivos = 0;
            foreach(AlienEnemigo al in listaAliens)
            {
                if (al.Activo)
                    aliensvivos++;
            }

            if (aliensvivos <= 6)
                intervaloDisparoAlien = 1f / multiCadenciaDificultad[dificultad];
            else
                intervaloDisparoAlien = 0.2f / multiCadenciaDificultad[dificultad];


            // Contar las columnas que tienen un alien habilitado
            int total = 0;

            foreach (AlienEnemigo al in listaAliens)
            {
                if (!al.Activo)
                    continue;

                bool tieneAlienDebajo = false;

                foreach (AlienEnemigo otro in listaAliens)
                {
                    if (otro.Activo && otro.Hitbox.X == al.Hitbox.X && otro.Hitbox.Y > al.Hitbox.Y)
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

            // Elegir un alien habilitado al azar
            int elegido = azar.Next(total);
            int contador = 0;

            foreach (AlienEnemigo al in listaAliens)
            {
                if (!al.Activo)
                    continue;

                bool tieneAlienDebajo = false;

                foreach (AlienEnemigo otro in listaAliens)
                {
                    if (otro.Activo && otro.Hitbox.X == al.Hitbox.X && otro.Hitbox.Y > al.Hitbox.Y)
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
                        disparo.Velocidad = 8;

                        disparosAliens.Add(disparo);
                        break;
                    }

                    contador++;
                }
            }
        }
        private void IniciarBoss()
        {
            // Si existe una fila "Alien Boss" en AliensTypes, usa su vida y puntos
            DatosAlien datos = tiposAliens.Find(a => a.Nombre == "Alien Boss");

            if (datos == null)
            {
                datos = new DatosAlien();
                datos.IDAlienType = 0;
                datos.Nombre = "Alien Boss";
                datos.Vida = VIDA_BOSS;
                datos.Puntos = PUNTOS_BOSS;
            }

            Vector2 posInicial = new Vector2((GraphicsDevice.Viewport.Width - spriteBoss.Width) / 2f, 80);

            boss = new AlienEnemigo(posInicial, spriteBoss.Width * 2, spriteBoss.Height * 2, datos);

            boss.Vida = Math.Max(1, (int)Math.Round(boss.Vida * multiVidaDificultad[dificultad]));
            boss.VidaMaxima = boss.Vida;

            // Direccion horizontal inicial al azar
            float vx = azar.Next(2) == 0 ? 250f : -250f;
            bossVelocidad = new Vector2(vx, 180f);

            tiempoDisparoBoss = 0f;
            bossAparecio = true;
        }

        private void ActualizarBoss(float tiempo)
        {
            boss.Posicion += bossVelocidad * tiempo;

            int anchoPantalla = GraphicsDevice.Viewport.Width;
            int limiteInferior = obstaculos[0].Area.Y - 200; 

            // Rebote en las paredes: se invierte la velocidad del eje que choco
            if (boss.Posicion.X < 0)
            {
                boss.Posicion.X = 0;
                bossVelocidad.X = -bossVelocidad.X;
            }
            else if (boss.Posicion.X + spriteBoss.Width * 2 > anchoPantalla)
            {
                boss.Posicion.X = anchoPantalla - spriteBoss.Width * 2;
                bossVelocidad.X = -bossVelocidad.X;
            }

            if (boss.Posicion.Y < 0)
            {
                boss.Posicion.Y = 0;
                bossVelocidad.Y = -bossVelocidad.Y;
            }
            else if (boss.Posicion.Y + spriteBoss.Height * 2 > limiteInferior)
            {
                boss.Posicion.Y = limiteInferior - spriteBoss.Height * 2;
                bossVelocidad.Y = -bossVelocidad.Y;
            }

            // La hitbox acompana al sprite
            boss.Hitbox.X = (int)boss.Posicion.X;
            boss.Hitbox.Y = (int)boss.Posicion.Y;

            tiempoDisparoBoss += tiempo;

            if (tiempoDisparoBoss >= intervaloDisparoBoss / multiCadenciaDificultad[dificultad])
            {
                DispararBoss();
                tiempoDisparoBoss = 0f;
            }
        }

        private void DispararBoss()
        {
            int x = boss.Hitbox.X + (boss.Hitbox.Width / 2) - 3;
            int y = boss.Hitbox.Bottom;

            Disparo disparo = new Disparo(x, y);

            // Cada disparo sale lento o rapido al azar
            if (azar.Next(2) == 0)
                disparo.Velocidad = VELOCIDAD_DISPARO_LENTO;
            else
                disparo.Velocidad = VELOCIDAD_DISPARO_RAPIDO;

            disparosAliens.Add(disparo);
        }

        // ---------------- JUEGO ----------------

        private void ActualizarPartida(GameTime gameTime)
        {
            float tiempo = (float)gameTime.ElapsedGameTime.TotalSeconds;
            tiempoDesdeDisparo += tiempo;

            if (tiempoAvisoNivel > 0f)
                tiempoAvisoNivel -= tiempo;

            // Movimiento de la nave
            if (teclaActual.IsKeyDown(Keys.Right) || teclaActual.IsKeyDown(Keys.D))
            {
                posicion.X += velocidad * tiempo;
            }

            if (teclaActual.IsKeyDown(Keys.Left) || teclaActual.IsKeyDown(Keys.A))
            {
                posicion.X -= velocidad * tiempo;
            }

            posicion.X = MathHelper.Clamp(posicion.X, 0, GraphicsDevice.Viewport.Width - spriteNave.Width);

            // Disparar
            if (teclaActual.IsKeyDown(Keys.Space) && tiempoDesdeDisparo >= cooldownDisparo)
            {
                int xBalas = (int)posicion.X + (spriteNave.Width / 2) - 3;

                int yBalas = (int)posicion.Y;

                listaDisparos.Add(new Disparo(xBalas, yBalas));

                tiempoDesdeDisparo = 0f;   // reinicia la espera
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
            // Boss: colision con las balas del jugador y movimiento
            if (bossAparecio && boss.Activo)
            {
                for (int i = 0; i < listaDisparos.Count; i++)
                {
                    if (boss.Activo && listaDisparos[i].Rectangulo.Intersects(boss.Hitbox))
                    {
                        bool eliminado = boss.RecibirDano(dano);

                        if (eliminado)
                        {
                            puntaje += boss.Puntos;
                            enemigosEliminados++;
                        }

                        listaDisparos.RemoveAt(i);
                        i--;
                    }
                }

                if (boss.Activo)
                    ActualizarBoss(tiempo);
            }

            // Subida de nivel: se alcanza el puntaje necesario del nivel siguiente
            if (nivelActual + 1 < niveles.Count &&
                puntaje >= niveles[nivelActual + 1].PuntosNecesarios)
            {
                // Se guarda lo que paso en el nivel que termina
                GuardarNivelActual();

                nivelActual++;
                puntajeInicioNivel = puntaje;
                enemigosInicioNivel = enemigosEliminados;
                fechaInicioNivel = DateTime.Now;

                AplicarNivel();

                tiempoAvisoNivel = 2f;
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
                    if (obstaculos[j].Activo && d.Rectangulo.Intersects(obstaculos[j].Area))
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
                Rectangle hitboxJugador = new Rectangle((int)posicion.X, (int)posicion.Y, spriteNave.Width, spriteNave.Height);

                if (d.Rectangulo.Intersects(hitboxJugador))
                {
                    vidas--;

                    disparosAliens.RemoveAt(i);
                    i--;
                }
            }

            // Derrota: se guarda el nivel actual y se cierra la sesion
            if (vidas <= 0)
            {
                if (!resultadoGuardado)
                {
                    GuardarNivelActual();
                    FinalizarSesion("Derrota");

                    resultadoGuardado = true;
                }

                victoria = false;
                gameOver = true;
                return;
            }

            int aliensVivos = 0;

            foreach (AlienEnemigo al in listaAliens)
            {
                if (al.Activo)
                {
                    aliensVivos++;
                }
            }

            // Cuando no quedan aliens, aparece el boss
            if (aliensVivos == 0 && !bossAparecio)
            {
                IniciarBoss();
            }

            // Victoria: el boss fue derrotado
            if (bossAparecio && !boss.Activo)
            {
                if (!resultadoGuardado)
                {
                    GuardarNivelActual();
                    FinalizarSesion("Victoria");

                    resultadoGuardado = true;
                }

                victoria = true;
                gameOver = true;
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

                    _spriteBatch.Draw(sprite, al.Posicion, Color.White);
                }
            }
            // Boss y su barra de vida
            if (bossAparecio && boss.Activo)
            {
                _spriteBatch.Draw(spriteBoss, boss.Hitbox, Color.White);

                Rectangle fondoBarra = new Rectangle(312, 10, 400, 16);
                int anchoVida = (int)(fondoBarra.Width * (float)boss.Vida / boss.VidaMaxima);

                _spriteBatch.Draw(pixel, fondoBarra, Color.DarkRed);
                _spriteBatch.Draw(pixel, new Rectangle(fondoBarra.X, fondoBarra.Y, anchoVida, fondoBarra.Height), Color.LimeGreen);
            }

            foreach (Disparo disparo in listaDisparos)
            {
                _spriteBatch.Draw(pixel, disparo.Rectangulo, Color.Cyan);
            }

            _spriteBatch.DrawString(fuente, "Jugador: " + menu.NombreJugador, new Vector2(10, 70), Color.White);

            _spriteBatch.DrawString(fuente, "Vidas: " + vidas, new Vector2(10, 10), Color.White);

            _spriteBatch.DrawString(fuente, "Puntaje: " + puntaje, new Vector2(10, 40), Color.Yellow);

            _spriteBatch.DrawString(fuente, "Nivel: " + (nivelActual + 1) + "/" + niveles.Count, new Vector2(10, 100), Color.LightGreen);

            foreach (Disparo disparo in disparosAliens)
            {
                _spriteBatch.Draw(pixel, disparo.Rectangulo, Color.Red);
            }

            foreach (Obstaculo obstaculo in obstaculos)
            {
                if (obstaculo.Activo)
                {
                    _spriteBatch.Draw(pixel, obstaculo.Area, Color.Red);
                }
            }

            // Aviso al subir de nivel
            if (tiempoAvisoNivel > 0f)
            {
                string aviso = "NIVEL " + (nivelActual + 1) + "!";
                Vector2 medida = fuente.MeasureString(aviso) * 2f;

                _spriteBatch.DrawString(fuente, aviso, new Vector2((GraphicsDevice.Viewport.Width - medida.X) / 2f, 450), Color.Gold, 0f, Vector2.Zero, 2f, SpriteEffects.None, 0f);
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

            _spriteBatch.DrawString(fuente, titulo, new Vector2(centroX - medidaTitulo.X / 2, centroY - 100), Color.Red);

            _spriteBatch.DrawString(fuente, resultado, new Vector2(centroX - medidaResultado.X / 2, centroY - 20), Color.White);

            _spriteBatch.DrawString(fuente, mensaje, new Vector2(centroX - medidaMensaje.X / 2, centroY + 50), Color.Yellow);

            // Si fallo el guardado en MySQL, se avisa en pantalla
            if (errorBase != "")
            {
                _spriteBatch.DrawString(fuente, errorBase, new Vector2(10, 980), Color.OrangeRed, 0f, Vector2.Zero, 0.6f, SpriteEffects.None, 0f);
            }
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
                    Vector2 posInicial = new Vector2(80 + (i * 100), 100 + (x * 100));

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

                    AlienEnemigo alien = new AlienEnemigo(posInicial, spriteElegido.Width, spriteElegido.Height, tipoElegido);

                    alien.Vida = Math.Max(1, (int)Math.Round(alien.Vida * multiVidaDificultad[dificultad]));
                    alien.VidaMaxima = alien.Vida;

                    listaAliens.Add(alien);
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
