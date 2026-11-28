using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
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

        private const int MAX_NOMBRE = 20;

        private static readonly Color TextoOscuro = new Color(25, 55, 100);
        private static readonly Color TextoSuave = new Color(120, 130, 145);

        private EstadoMenu estadoActual = EstadoMenu.Nombre;

        private Ranking ranking = new Ranking();
        private string mensajeRanking = "";

        private GameWindow ventana;
        private SpriteFont fuente;
        private Texture2D pixel;
        // imaganes para el menu de naves(titulom tarjetas azul y verde, botonjugar, LAS NAVES para las tarjetas)
        private ContentManager content;
        private Texture2D texNave1; 
        private Texture2D texNave2;
        private Texture2D texNave3;
        private Texture2D texTitulo;
        private Texture2D texBotonJugar;
        private Texture2D texTarjetaAzul;
        private Texture2D texTarjetaVerde;
        private Texture2D texFacil, texMedio, texDificil;
        private Texture2D texFacilPresionado, texMedioPresionado, texDificilPresionado;
        private Rectangle rectTitulo = new Rectangle(297, 130, 429, 67);
        // Imagenes del menu (Content: logo, panel_nombre, boton_continuar, panel_ranking)
        private Texture2D texLogo;
        private Texture2D texPanelNombre;
        private Texture2D texBoton;
        private Texture2D texPanelRanking;

        // Posiciones en pantalla (ventana de 1024x1024)
        private Rectangle pantalla = new Rectangle(0, 0, 1024, 1024);
        private Rectangle rectLogo = new Rectangle(60, 190, 500, 270);
        private Rectangle rectPanelNombre = new Rectangle(60, 480, 500, 166);
        private Rectangle botonContinuar = new Rectangle(130, 670, 360, 90);
        private Rectangle rectRanking = new Rectangle(590, 250, 400, 501);
        private Rectangle botonJugar = new Rectangle(392, 880, 240, 81);

        private Rectangle rectFacil = new Rectangle(282, 710, 140, 90);
        private Rectangle rectMedio = new Rectangle(442, 710, 140, 90);
        private Rectangle rectDificil = new Rectangle(602, 710, 140, 90);

        // Se calculan en el constructor segun el tamano de cada imagen
        private Rectangle campoNombre;
        private float escalaRanking;

        private string nombreJugador = "";
        private int idJugador;

        private List<DatosNave> naves = new List<DatosNave>();
        private int naveSeleccionada = 0;
        private int dificultad = 1;

        private string mensajeMenu = "";
        private bool errorMenu = false;

        private KeyboardState teclaActual;
        private KeyboardState teclaAnterior;

        private MouseState mouseActual;
        private MouseState mouseAnterior;

        public bool InicioSolicitado { get; private set; }
        public bool SolicitaSalir { get; private set; }

        public DatosNave NaveElegida
        {
            get { return naves[naveSeleccionada]; }
        }
        public int Dificultad
        {
            get { return dificultad; }
        }
        public int IdJugador
        {
            get { return idJugador; }
        }

        public string NombreJugador
        {
            get { return nombreJugador; }
        }
        private float YTarjeta(Rectangle tarjeta, float fraccion, float escala)
        {
            return tarjeta.Y + tarjeta.Height * fraccion - fuente.LineSpacing * escala / 2f;
        }
        private Texture2D ObtenerSpriteNave(int indice)
        {
            if (indice == 0)
                return texNave1;

            if (indice == 1)
                return texNave2;

            return texNave3;
        }
        public Menu(GameWindow ventana, ContentManager content, SpriteFont fuente, Texture2D pixel)
        {
            this.content = content; 
            this.ventana = ventana;
            this.fuente = fuente;
            this.pixel = pixel;

            texLogo = content.Load<Texture2D>("logo");
            texPanelNombre = content.Load<Texture2D>("panel_nombre");
            texBoton = content.Load<Texture2D>("boton_continuar");
            texPanelRanking = content.Load<Texture2D>("panel_ranking");

            texTitulo = content.Load<Texture2D>("titulo_elegir_nave");
            texBotonJugar = content.Load<Texture2D>("boton_jugar");
            texTarjetaAzul = content.Load<Texture2D>("tarjeta_azul");
            texTarjetaVerde = content.Load<Texture2D>("tarjeta_verde");

            texFacil = content.Load<Texture2D>("boton_facil");
            texMedio = content.Load<Texture2D>("boton_medio");
            texDificil = content.Load<Texture2D>("boton_dificil");
            texFacilPresionado = content.Load<Texture2D>("boton_facil_presionado");
            texMedioPresionado = content.Load<Texture2D>("boton_medio_presionado");
            texDificilPresionado = content.Load<Texture2D>("boton_dificil_presionado");


            // Caja de escritura dentro de panel_nombre.png
            // (medida sobre la imagen original: x 60, y 107, 665 x 90)
            float e = rectPanelNombre.Width / (float)texPanelNombre.Width;
            campoNombre = new Rectangle(rectPanelNombre.X + (int)(60 * e), rectPanelNombre.Y + (int)(107 * e), (int)(665 * e), (int)(90 * e)
            );

            escalaRanking = rectRanking.Width / (float)texPanelRanking.Width;

            ventana.TextInput += EscribirNombre;

            CargarRanking();
        }

        // ---------------- LOGICA ----------------

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

        private void EscribirNombre(object sender, TextInputEventArgs e)
        {
            if (estadoActual != EstadoMenu.Nombre)
                return;

            if (!char.IsControl(e.Character) && nombreJugador.Length < MAX_NOMBRE)
            {
                nombreJugador += e.Character;
            }
        }

        public void Actualizar()
        {
            teclaActual = Keyboard.GetState();
            mouseActual = Mouse.GetState();

            if (Presionada(Keys.Escape))
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
                ActualizarMenuNombre();
            else
                ActualizarMenuNaves();

            teclaAnterior = teclaActual;
            mouseAnterior = mouseActual;
        }

        private bool Presionada(Keys tecla)
        {
            return teclaActual.IsKeyDown(tecla) && teclaAnterior.IsKeyUp(tecla);
        }

        private bool ClicEn(Rectangle area)
        {
            return mouseActual.LeftButton == ButtonState.Pressed && mouseAnterior.LeftButton == ButtonState.Released && area.Contains(mouseActual.Position);
        }

        private void ActualizarMenuNombre()
        {
            if (Presionada(Keys.Back) && nombreJugador.Length > 0)
            {
                nombreJugador = nombreJugador.Substring(0, nombreJugador.Length - 1);
            }

            if (Presionada(Keys.Enter) || ClicEn(botonContinuar))
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
                texNave1 = content.Load<Texture2D>(naves[0].Nombre);
                texNave2 = content.Load<Texture2D>(naves[1].Nombre);
                texNave3 = content.Load<Texture2D>(naves[2].Nombre);

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
            if (Presionada(Keys.Left))
            {
                naveSeleccionada--;

                if (naveSeleccionada < 0)
                    naveSeleccionada = naves.Count - 1;
            }

            if (Presionada(Keys.Right))
            {
                naveSeleccionada++;

                if (naveSeleccionada >= naves.Count)
                    naveSeleccionada = 0;
            }

            for (int i = 0; i < naves.Count; i++)
            {
                if (ClicEn(ObtenerTarjetaNave(i)))
                {
                    naveSeleccionada = i;
                }
            }
            if (ClicEn(rectFacil))
                dificultad = 0;

            if (ClicEn(rectMedio))
                dificultad = 1;

            if (ClicEn(rectDificil))
                dificultad = 2;

            if (Presionada(Keys.Enter) || ClicEn(botonJugar))
            {
                ComenzarPartida();
            }
        }

        private Rectangle ObtenerTarjetaNave(int indice)
        {
            int ancho = 260;
            int espacio = 25;

            int total = naves.Count * ancho + (naves.Count - 1) * espacio;
            int inicio = (pantalla.Width - total) / 2;

            return new Rectangle(inicio + indice * (ancho + espacio), 350, ancho, 340);
        }

        private void ComenzarPartida()
        {
            if (naves.Count == 0)
                return;

            try
            {
                BaseDatos.GuardarNaveElegida(
                    idJugador,
                    naves[naveSeleccionada].IDNave
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

        // ---------------- DIBUJO ----------------

        public void Dibujar(SpriteBatch spriteBatch)
        {
            if (estadoActual == EstadoMenu.Nombre)
                DibujarMenuNombre(spriteBatch);
            else
                DibujarMenuNaves(spriteBatch);
        }

        private void DibujarMenuNombre(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(texLogo, rectLogo, Color.White);
            spriteBatch.Draw(texPanelNombre, rectPanelNombre, Color.White);
            spriteBatch.Draw(texBoton, botonContinuar, Color.White);

            // Texto escrito (o sugerencia si todavia esta vacio)
            bool vacio = nombreJugador.Length == 0;
            string texto = vacio ? "Escribi tu nombre de usuario..." : nombreJugador;

            float y = campoNombre.Center.Y - fuente.LineSpacing / 2f;

            DibujarTexto(spriteBatch, texto, new Vector2(campoNombre.X + 30, y + 55), vacio ? TextoSuave : TextoOscuro, 1f);

            DibujarMensajeMenu(spriteBatch, rectPanelNombre, 630);
            DibujarRanking(spriteBatch);
        }

        private void DibujarRanking(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(texPanelRanking, rectRanking, Color.White);

            if (mensajeRanking != "")
            {
                DibujarTextoCentrado(spriteBatch, mensajeRanking, rectRanking, rectRanking.Y + 230, Color.DarkRed, 0.7f);
                return;
            }

            if (ranking.Cantidad == 0)
            {
                DibujarTextoCentrado(spriteBatch, "Todavia no hay resultados.", rectRanking, rectRanking.Y + 220, TextoOscuro, 0.7f);
                return;
            }

            float escala = 0.7f;

            // Medidas tomadas sobre panel_ranking.png original (635 x 795):
            // primera fila centrada en y=152, 68.5 px entre filas,
            // pestana del numero en x=92, nombre desde x=135, puntaje hasta x=570
            for (int i = 0; i < 9 && i<ranking.Cantidad; i++)
            {
                DatosRanking jugador = ranking.Obtener(i);

                float centroY = rectRanking.Y + (152 + 68.5f * i) * escalaRanking;
                float y = centroY - fuente.LineSpacing * escala / 2f;

                // Numero de posicion, centrado en la pestana azul
                string posicion = (i + 1).ToString();
                float anchoPos = fuente.MeasureString(posicion).X * escala;
                float xPestana = rectRanking.X + 92 * escalaRanking;

                DibujarTexto(spriteBatch, posicion, new Vector2(xPestana - anchoPos / 2f, y), TextoOscuro, escala);

                // Nombre
                string nombre = jugador.Nombre;
                if (nombre.Length > 20)
                    nombre = nombre.Substring(0, 20);

                DibujarTexto(spriteBatch, nombre,new Vector2(rectRanking.X + 135 * escalaRanking, y),TextoOscuro, escala);

                // Puntaje alineado a la derecha
                string puntos = jugador.PuntajeAcumulado.ToString();
                float anchoPuntos = fuente.MeasureString(puntos).X * escala;
                float xDerecha = rectRanking.X + 570 * escalaRanking;

                DibujarTexto(spriteBatch, puntos, new Vector2(xDerecha - anchoPuntos, y), TextoOscuro, escala);
            }
        }

        private void DibujarMenuNaves(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(texTitulo, rectTitulo, Color.White);

            DibujarTextoCentrado(spriteBatch, "Jugador: " + nombreJugador, pantalla, 250, Color.White, 1f);

            float escala = 0.7f;
            float[] filasY = { 0.568f, 0.640f, 0.715f, 0.792f };

            for (int i = 0; i < naves.Count; i++)
            {
                DatosNave nave = naves[i];
                Rectangle tarjeta = ObtenerTarjetaNave(i);
                bool elegida = i == naveSeleccionada;

                spriteBatch.Draw(elegida ? texTarjetaVerde : texTarjetaAzul, tarjeta, Color.White);

                // Nombre, en la etiqueta de arriba
                DibujarTextoCentrado(spriteBatch, nave.Nombre, tarjeta,
                YTarjeta(tarjeta, 0.077f, 0.8f), Color.White, 0.8f);

                // Solo los valores: "Vida:", "Daño:", etc. ya vienen en la imagen
                string[] valores =
                {
                    nave.Vida.ToString(),
                    nave.Dano.ToString(),
                    nave.Velocidad.ToString(),
                    nave.Cadencia.ToString()
                };

                for (int j = 0; j < valores.Length; j++)
                {
                    float ancho = fuente.MeasureString(valores[j]).X * escala;
                    float x = tarjeta.X + tarjeta.Width * 0.855f - ancho;

                    if(elegida)
                        DibujarTexto(spriteBatch, valores[j], new Vector2(x, YTarjeta(tarjeta, filasY[j], escala) -4), Color.White, escala);
                    else
                        DibujarTexto(spriteBatch, valores[j], new Vector2(x, YTarjeta(tarjeta, filasY[j], escala) +2), Color.White, escala);
                }

                DibujarSpriteEnMarco(spriteBatch, ObtenerSpriteNave(i), tarjeta);

                // Etiqueta de abajo
                DibujarTextoCentrado(spriteBatch,
                elegida ? "SELECCIONADA" : "ELEGIR",
                tarjeta, YTarjeta(tarjeta, 0.90f, 0.6f),
                elegida ? Color.Yellow : Color.LightGray, 0.6f);
            }
            // El botón elegido se dibuja con la imagen "presionado"
            spriteBatch.Draw(dificultad == 0 ? texFacilPresionado : texFacil, rectFacil, Color.White);
            spriteBatch.Draw(dificultad == 1 ? texMedioPresionado : texMedio, rectMedio, Color.White);
            spriteBatch.Draw(dificultad == 2 ? texDificilPresionado : texDificil, rectDificil, Color.White);

            spriteBatch.Draw(texBotonJugar, botonJugar, Color.White);

        }
        private void DibujarSpriteEnMarco(SpriteBatch spriteBatch, Texture2D sprite, Rectangle tarjeta)
        {
            Rectangle marco = new Rectangle(tarjeta.X + (int)(tarjeta.Width * 0.10f),tarjeta.Y + (int)(tarjeta.Height * 0.17f),(int)(tarjeta.Width * 0.79f),(int)(tarjeta.Height * 0.33f));

            int margen = 10;

            float escala = Math.Min(
                (marco.Width - margen * 2) / (float)sprite.Width,
                (marco.Height - margen * 2) / (float)sprite.Height);

            int ancho = (int)(sprite.Width * escala);
            int alto = (int)(sprite.Height * escala);

            Rectangle destino = new Rectangle(
                marco.Center.X - ancho / 2,
                marco.Center.Y - alto / 2,
                ancho,
                alto);

            spriteBatch.Draw(sprite, destino, Color.White);
        }

        private void DibujarBoton(SpriteBatch spriteBatch, Rectangle area, string texto)
        {
            spriteBatch.Draw(pixel, area, new Color(0, 130, 160));

            DibujarTextoCentrado(spriteBatch, texto, area,
                area.Y + (area.Height - fuente.LineSpacing) / 2, Color.White, 1f);
        }

        private void DibujarMensajeMenu(SpriteBatch spriteBatch, Rectangle area, int y)
        {
            Color color = errorMenu ? Color.OrangeRed : Color.LightGreen;

            DibujarTextoCentrado(spriteBatch, mensajeMenu, area, y, color, 0.7f);
        }

        // ---------------- AYUDAS DE TEXTO ----------------

        private void DibujarTexto(SpriteBatch spriteBatch, string texto, Vector2 posicion, Color color, float escala)
        {
            spriteBatch.DrawString(fuente, texto, posicion, color,
                0f, Vector2.Zero, escala, SpriteEffects.None, 0f);
        }

        // Centra el texto horizontalmente dentro de "area"
        private void DibujarTextoCentrado(SpriteBatch spriteBatch, string texto, Rectangle area, float y, Color color, float escala)
        {
            float ancho = fuente.MeasureString(texto).X * escala;
            float x = area.X + (area.Width - ancho) / 2f;

            DibujarTexto(spriteBatch, texto, new Vector2(x, y), color, escala);
        }
    }
}
