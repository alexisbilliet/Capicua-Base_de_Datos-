using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System.Collections.Generic;

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
        private Texture2D personaje;
        private Vector2 posicion;
        private float velocidad = 200f;
        private List<Obstaculo> obstaculos = new List<Obstaculo>();

        private Texture2D pixel;
        private SpriteFont fuente;
        private int vidas = 3;
        private int puntaje = 0;

        private Texture2D alien;
        private List<AlienEnemigo> listaAliens = new List<AlienEnemigo>();

        private List<Disparo> listaDisparos;
        private KeyboardState teclaActual;
        private KeyboardState teclaAnterior;

        private GraphicsDeviceManager _graphics;
        private SpriteBatch _spriteBatch;
        private Vector2 aux;
        public Game1()
        {
            _graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = true;

            _graphics.PreferredBackBufferWidth = 1024;
            _graphics.PreferredBackBufferHeight = 1024;
            _graphics.ApplyChanges();
        }

        protected override void Initialize()
        {
            listaDisparos = new List<Disparo>();
            base.Initialize();
        }

        protected override void LoadContent()
        {
            _spriteBatch = new SpriteBatch(GraphicsDevice);

            personaje = Content.Load<Texture2D>("personaje");
            posicion = new Vector2(500, 950);

            alien = Content.Load<Texture2D>("alien");
            for(int x = 0; x< 6; x++)
            {
                for (int i = 0; i < 9; i++)
                {
                    Vector2 posInicial = new Vector2(80 + (i * 100), 100 + (x * 100));
                    listaAliens.Add(new AlienEnemigo(posInicial, alien.Width, alien.Height));
                }
            }

            fuente = Content.Load<SpriteFont>("Arial");
            pixel = new Texture2D(GraphicsDevice, 1, 1);
            pixel.SetData(new[] { Color.White });

            obstaculos.Clear();

            //muro
            int anchoObstaculo = 100;
            int altoObstaculo = 30;
            int espacio = 120;

            int distanciaDesdeElFondo = 150;
            int posicionYBarrera = GraphicsDevice.Viewport.Height - distanciaDesdeElFondo;


            
             obstaculos.Add(new Obstaculo(181, 850, anchoObstaculo, altoObstaculo));
            obstaculos.Add(new Obstaculo(462, 850, anchoObstaculo, altoObstaculo));
            obstaculos.Add(new Obstaculo(743, 850, anchoObstaculo, altoObstaculo));

        }

        protected override void Update(GameTime gameTime)
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
                Exit();

            teclaActual = Keyboard.GetState();
            float tiempo = (float)gameTime.ElapsedGameTime.TotalSeconds;

            // movimiento del alien


            // movimiento de la nave
            if (teclaActual.IsKeyDown(Keys.Right) || teclaActual.IsKeyDown(Keys.D))
            {
                posicion.X += velocidad * tiempo;
            }
            if (teclaActual.IsKeyDown(Keys.Left) || teclaActual.IsKeyDown(Keys.A))
            {
                posicion.X -= velocidad * tiempo;
            }
            

            posicion.X = MathHelper.Clamp(posicion.X, 0, GraphicsDevice.Viewport.Width - personaje.Width);

            if (teclaActual.IsKeyDown(Keys.Space) && teclaAnterior.IsKeyUp(Keys.Space))
            {
                int xBalas = (int)posicion.X + (personaje.Width / 2) - 3;
                int yBalas = (int)posicion.Y;
                listaDisparos.Add(new Disparo(xBalas, yBalas));
            }

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

            //area de personajes
            Rectangle areaPersonaje = new Rectangle(
                (int)posicion.X,
                (int)posicion.Y,
                personaje.Width,
                personaje.Height
            );



            //colision de balas
            for (int i = 0; i < listaDisparos.Count; i++)
            {
                Disparo d = listaDisparos[i];
                d.Rectangulo.Y -= d.Velocidad;
                listaDisparos[i] = d;

                bool balaEliminada = false;

                // 1. Verificar colisión con la LISTA de aliens
                for (int k = 0; k < listaAliens.Count; k++)
                {
                    AlienEnemigo al = listaAliens[k];

                    // Si el alien ya está muerto, pasamos al siguiente
                    if (!al.Activo) continue;

                    if (d.Rectangulo.Intersects(al.Hitbox))
                    {
                        al.Activo = false;       // Desactivamos el alien destruido
                        listaAliens[k] = al;    // Guardamos el cambio en la lista

                        puntaje += 10;          // Sumamos puntos
                        listaDisparos.RemoveAt(i);
                        i--;
                        balaEliminada = true;
                        break;                  // Rompemos el bucle de aliens porque la bala desapareció
                    }
                }

                // Si la bala ya pegó en un alien, saltamos al siguiente disparo
                if (balaEliminada) continue;

                // 2. Verificar colisión con obstáculos (tu código original)
                



                // 3. Eliminar bala si sale de la pantalla
                if (d.Rectangulo.Y + d.Rectangulo.Height < 0)
                {
                    listaDisparos.RemoveAt(i);
                    i--;
                }
            }


            // Guardar el estado del teclado para el siguiente ciclo
            teclaAnterior = teclaActual;

            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(new Color(10, 20, 40));

            _spriteBatch.Begin();

            //dibujar personajes
            _spriteBatch.Draw(
                personaje,
                posicion,
                Color.White
            );

            foreach (AlienEnemigo al in listaAliens)
            {
                if (al.Activo)
                {
                    _spriteBatch.Draw(alien, al.Posicion, Color.White);
                }
            }

            // Dibujar los disparos
            foreach (Disparo disparo in listaDisparos)
            {
                _spriteBatch.Draw(pixel, disparo.Rectangulo, Color.Cyan);
            }

            // Dibujar vidas
            _spriteBatch.DrawString(
                fuente,
                "Vidas: " + vidas,
                new Vector2(10, 10),
                Color.White
            );

            // Dibujar puntaje
            _spriteBatch.DrawString(
                fuente,
                "Puntaje: " + puntaje,
                new Vector2(10,40),
                Color.Yellow
            );

            // Dibujar obstáculos activos
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

            // Mostrar registros de la pila
            _spriteBatch.End();
            base.Draw(gameTime);
        }
    }
}