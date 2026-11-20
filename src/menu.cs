
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;

namespace Project2
{
    public class Menu
    {
        private enum EstadoMenu
        {
            Nombre,
            Naves
        }
        private Ranking ranking = new Ranking();
        private string mensajeRanking = "";
        private EstadoMenu estadoActual = EstadoMenu.Nombre;

        private GameWindow ventana;
        private SpriteFont fuente;
        private Texture2D pixel;

        private string nombreJugador = "";
        private int idJugador;

        private List<DatosNave> naves = new List<DatosNave>();
        private int naveSeleccionada = 0;

        private string mensajeMenu = "";
        private bool errorMenu = false;

        private KeyboardState teclaActual;
        private KeyboardState teclaAnterior;

        private MouseState mouseActual;
        private MouseState mouseAnterior;

        private Rectangle botonContinuar =
        new Rectangle(160, 600, 300, 65);

        private Rectangle botonJugar =
            new Rectangle(362, 800, 300, 65);

        public bool InicioSolicitado { get; private set; }
        public bool SolicitaSalir { get; private set; }

        public DatosNave NaveElegida
        {
            get { return naves[naveSeleccionada]; }
        }

        public int IdJugador
        {
            get { return idJugador; }
        }

        public string NombreJugador
        {
            get { return nombreJugador; }
        }

        public Menu(GameWindow ventana, SpriteFont fuente, Texture2D pixel)
        {
            this.ventana = ventana;
            this.fuente = fuente;
            this.pixel = pixel;

            ventana.TextInput += EscribirNombre;

            CargarRanking();

        }
        private void CargarRanking()
        {
            try
            {
                ranking.Cargar();
                mensajeRanking = "";
        }
            catch (Exception)
            {
                mensajeRanking = "No se pudo cargar el ranking.";
            }
        }       

        private void DibujarRanking(SpriteBatch spriteBatch)
        {
            Rectangle panel = new Rectangle(570, 330, 390, 490);

            spriteBatch.Draw(pixel, panel, new Color(20, 35, 60));

            DibujarTextoTarjeta(
            spriteBatch,
            "TOP 10 JUGADORES",
            panel,
            345,
            Color.Cyan,
            1f
        );

            if (mensajeRanking != "")
            {
                DibujarTextoTarjeta(
                    spriteBatch,
                    mensajeRanking,
                    panel,
                    410,
                    Color.OrangeRed,
                    0.7f
                );

                return;
            }

            if (ranking.Cantidad == 0)
            {
                DibujarTextoTarjeta(
                 spriteBatch,
                 "Todavia no hay resultados.",
                    panel,
                    420,
                    Color.LightGray,
                    0.7f
                );

                return;
            }

            for (int i = 0; i < ranking.Cantidad && i < 10; i++)
            {
                DatosRanking jugador = ranking.Obtener(i);

                int y = 400 + i * 38;

                string texto =
            (       i + 1) + ". " + jugador.Nombre;

                spriteBatch.DrawString(
                    fuente,
                    texto,
                    new Vector2(panel.X + 20, y),
                    Color.White,
                    0f,
                    Vector2.Zero,
                    0.7f,
                    SpriteEffects.None,
                    0f
                );

                string puntos = jugador.PuntajeAcumulado.ToString();

                Vector2 medida = fuente.MeasureString(puntos) * 0.7f;

                spriteBatch.DrawString(
                    fuente,
                    puntos,
                    new Vector2(panel.Right - medida.X - 20, y),
                 Color.Yellow,
                    0f,
                    Vector2.Zero,
                    0.7f,
                    SpriteEffects.None,
                    0f
             );
            }
        }

        private void EscribirNombre(object sender, TextInputEventArgs e)
        {
            if (estadoActual != EstadoMenu.Nombre)
                return;

            if (!char.IsControl(e.Character) && nombreJugador.Length < 50)
            {
                nombreJugador += e.Character;
            }
        }

        public void Actualizar()
        {
            teclaActual = Keyboard.GetState();
            mouseActual = Mouse.GetState();

            bool escapePresionado =
                teclaActual.IsKeyDown(Keys.Escape) &&
                teclaAnterior.IsKeyUp(Keys.Escape);

            if (escapePresionado)
            {
                if (estadoActual == EstadoMenu.Naves)
                {
                    estadoActual = EstadoMenu.Nombre;
                    mensajeMenu = "";
                }
                else
                {
                    SolicitaSalir = true;
                }
            }

            if (estadoActual == EstadoMenu.Nombre)
            {
                ActualizarMenuNombre();
            }
            else if (estadoActual == EstadoMenu.Naves)
            {
                ActualizarMenuNaves();
            }

            teclaAnterior = teclaActual;
            mouseAnterior = mouseActual;
        }

        private void ActualizarMenuNombre()
        {
            bool enterPresionado =
                teclaActual.IsKeyDown(Keys.Enter) &&
                teclaAnterior.IsKeyUp(Keys.Enter);

            bool borrarPresionado =
                teclaActual.IsKeyDown(Keys.Back) &&
                teclaAnterior.IsKeyUp(Keys.Back);

            bool click =
                mouseActual.LeftButton == ButtonState.Pressed &&
                mouseAnterior.LeftButton == ButtonState.Released;

            if (borrarPresionado && nombreJugador.Length > 0)
            {
                nombreJugador =
                    nombreJugador.Substring(0, nombreJugador.Length - 1);
            }

            if (enterPresionado ||
                (click && botonContinuar.Contains(mouseActual.Position)))
            {
                BuscarJugador();
            }
        }

        private void BuscarJugador()
        {
            nombreJugador = nombreJugador.Trim();

            if (nombreJugador.Length == 0)
            {
                mensajeMenu = "Escribi un nombre para continuar.";
                errorMenu = true;
                return;
            }

            try
            {
                idJugador = BaseDatos.ObtenerOCrearJugador(nombreJugador);

                naves = BaseDatos.CargarNaves();

                if (naves.Count == 0)
                {
                    mensajeMenu = "No hay naves en la base de datos.";
                    errorMenu = true;
                    return;
                }

                naveSeleccionada = 0;
                estadoActual = EstadoMenu.Naves;

                mensajeMenu = "Selecciona una nave.";
                errorMenu = false;
            }
            catch (Exception ex)
            {
                mensajeMenu = "Error de MySQL: " + ex.Message;
                errorMenu = true;
            }
        }

        private void ActualizarMenuNaves()
        {
            bool izquierda =
                teclaActual.IsKeyDown(Keys.Left) &&
                teclaAnterior.IsKeyUp(Keys.Left);

            bool derecha =
                teclaActual.IsKeyDown(Keys.Right) &&
                teclaAnterior.IsKeyUp(Keys.Right);

            bool enterPresionado =
                teclaActual.IsKeyDown(Keys.Enter) &&
                teclaAnterior.IsKeyUp(Keys.Enter);

            bool click =
                mouseActual.LeftButton == ButtonState.Pressed &&
                mouseAnterior.LeftButton == ButtonState.Released;

            if (izquierda)
            {
                naveSeleccionada--;

                if (naveSeleccionada < 0)
                    naveSeleccionada = naves.Count - 1;
            }

            if (derecha)
            {
                naveSeleccionada++;

                if (naveSeleccionada >= naves.Count)
                    naveSeleccionada = 0;
            }

            for (int i = 0; i < naves.Count; i++)
            {
                Rectangle tarjeta = ObtenerTarjetaNave(i);

                if (click && tarjeta.Contains(mouseActual.Position))
                {
                    naveSeleccionada = i;
                }
            }

            if (enterPresionado ||
                (click && botonJugar.Contains(mouseActual.Position)))
            {
                ComenzarPartida();
            }
        }

        private Rectangle ObtenerTarjetaNave(int indice)
        {
            int ancho = 220;
            int espacio = 25;

            int total =
                naves.Count * ancho +
                (naves.Count - 1) * espacio;

            int inicio = (1024 - total) / 2;

            return new Rectangle(
                inicio + indice * (ancho + espacio),
                350,
                ancho,
                350
            );
        }

        private void ComenzarPartida()
        {
            if (naves.Count == 0)
                return;

            try
            {
                DatosNave nave = naves[naveSeleccionada];

                BaseDatos.GuardarNaveElegida(
                    idJugador,
                    nave.IDNave
                );

                InicioSolicitado = true;
            }
            catch (Exception ex)
            {
                mensajeMenu = "Error al guardar la nave: " + ex.Message;
                errorMenu = true;
            }
        }
        public void VolverAlMenu()
        {
            InicioSolicitado = false;
            estadoActual = EstadoMenu.Nombre;
            mensajeMenu = "";
            errorMenu = false;
            CargarRanking();
        }

        public void Dibujar(SpriteBatch spriteBatch)
        {
            if (estadoActual == EstadoMenu.Nombre)
            {
                DibujarMenuNombre(spriteBatch);
            }
            else if (estadoActual == EstadoMenu.Naves)
            {
                DibujarMenuNaves(spriteBatch);
            }
        }

        private void DibujarMenuNombre(SpriteBatch spriteBatch)
        {
            DibujarTextoTarjeta(
            spriteBatch,
            "ALIEN INVASION",
            new Rectangle(60, 150, 500, 100),
            180,
            Color.Cyan,
            2f
        );

        DibujarTextoTarjeta(
            spriteBatch,
            "INGRESA TU NOMBRE",
            new Rectangle(60, 300, 500, 60),
            350,
            Color.White,
            1.2f
        );

            Rectangle caja = new Rectangle(60, 430, 500, 65);

            spriteBatch.Draw(pixel, caja, Color.White);

            spriteBatch.Draw(
                pixel,
                new Rectangle(
                    caja.X + 3,
                    caja.Y + 3,
                    caja.Width - 6,
                    caja.Height - 6
                ),
                new Color(20, 35, 60)
            );

            string texto = nombreJugador;

            if (texto.Length == 0)
                texto = "Escribi tu nombre...";

            spriteBatch.DrawString(
                fuente,
                texto,
                new Vector2(85, 450),
                nombreJugador.Length == 0 ? Color.Gray : Color.White
            );

            DibujarBoton(spriteBatch, botonContinuar, "CONTINUAR");
            DibujarMensajeMenu(spriteBatch);

            DibujarRanking(spriteBatch);
        }

        private void DibujarMenuNaves(SpriteBatch spriteBatch)
        {
            DibujarTextoCentrado(
                spriteBatch,
                "ELEGIR NAVE",
                150,
                Color.Cyan,
                1.8f
            );

            DibujarTextoCentrado(
                spriteBatch,
                "Jugador: " + nombreJugador,
                250,
                Color.White,
                1f
            );

            for (int i = 0; i < naves.Count; i++)
            {
                DatosNave nave = naves[i];

                Rectangle tarjeta = ObtenerTarjetaNave(i);

                Color fondo =
                    i == naveSeleccionada
                    ? new Color(35, 90, 115)
                    : new Color(25, 40, 65);

                spriteBatch.Draw(pixel, tarjeta, fondo);

                spriteBatch.Draw(
                    pixel,
                    new Rectangle(
                        tarjeta.X,
                        tarjeta.Y,
                        tarjeta.Width,
                        5
                    ),
                    i == naveSeleccionada ? Color.Cyan : Color.Gray
                );

                DibujarTextoTarjeta(
                    spriteBatch,
                    nave.Nombre,
                    tarjeta,
                    tarjeta.Y + 40,
                    Color.White,
                    1f
                );

                DibujarTextoTarjeta(
                    spriteBatch,
                    "Vida: " + nave.Vida,
                    tarjeta,
                    tarjeta.Y + 120,
                    Color.LightGreen,
                    0.8f
                );

                DibujarTextoTarjeta(
                    spriteBatch,
                    "Dano: " + nave.Dano,
                    tarjeta,
                    tarjeta.Y + 165,
                    Color.Orange,
                    0.8f
                );

                DibujarTextoTarjeta(
                    spriteBatch,
                    "Velocidad: " + nave.Velocidad,
                    tarjeta,
                    tarjeta.Y + 210,
                    Color.LightBlue,
                    0.8f
                );

                DibujarTextoTarjeta(
                    spriteBatch,
                    "Cadencia: " + nave.Cadencia,
                    tarjeta,
                    tarjeta.Y + 255,
                    Color.White,
                    0.8f
                );

                if (i == naveSeleccionada)
                {
                    DibujarTextoTarjeta(
                        spriteBatch,
                        "SELECCIONADA",
                        tarjeta,
                        tarjeta.Y + 310,
                        Color.Yellow,
                        0.7f
                    );
                }
                else
                {
                    DibujarTextoTarjeta(
                        spriteBatch,
                        "CLIC PARA ELEGIR",
                        tarjeta,
                        tarjeta.Y + 310,
                        Color.Gray,
                        0.7f
                    );
                }
            }

            DibujarBoton(spriteBatch, botonJugar, "JUGAR");
            DibujarMensajeMenu(spriteBatch);

            DibujarTextoCentrado(
                spriteBatch,
                "Usa las flechas para cambiar de nave",
                750,
                Color.LightGray,
                0.7f
            );
        }

        private void DibujarBoton(
            SpriteBatch spriteBatch,
            Rectangle area,
            string texto)
        {
            spriteBatch.Draw(
                pixel,
                area,
                new Color(0, 130, 160)
            );

            Vector2 medida = fuente.MeasureString(texto);

            Vector2 posicionTexto = new Vector2(
                area.X + (area.Width - medida.X) / 2,
                area.Y + (area.Height - medida.Y) / 2
            );

            spriteBatch.DrawString(
                fuente,
                texto,
                posicionTexto,
                Color.White
            );
        }

        private void DibujarMensajeMenu(SpriteBatch spriteBatch)
        {
            Color color =
                errorMenu ? Color.OrangeRed : Color.LightGreen;

            DibujarTextoTarjeta(
                spriteBatch,
                mensajeMenu,
                new Rectangle(60, 680, 500, 40),
                680,
                color,
                0.7f
            );
        }

        private void DibujarTextoCentrado(
            SpriteBatch spriteBatch,
            string texto,
            float y,
            Color color,
            float escala)
        {
            Vector2 medida = fuente.MeasureString(texto) * escala;

            Vector2 posicionTexto = new Vector2(
                (1024 - medida.X) / 2,
                y
            );

            spriteBatch.DrawString(
                fuente,
                texto,
                posicionTexto,
                color,
                0f,
                Vector2.Zero,
                escala,
                SpriteEffects.None,
                0f
            );
        }

        private void DibujarTextoTarjeta(
            SpriteBatch spriteBatch,
            string texto,
            Rectangle tarjeta,
            int y,
            Color color,
            float escala)
        {
            Vector2 medida = fuente.MeasureString(texto) * escala;

            float x = tarjeta.X + (tarjeta.Width - medida.X) / 2;

            spriteBatch.DrawString(
                fuente,
                texto,
                new Vector2(x, y),
                color,
                0f,
                Vector2.Zero,
                escala,
                SpriteEffects.None,
                0f
            );
        }
    }
}
