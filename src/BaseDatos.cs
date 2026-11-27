using System;
using System.Collections.Generic;
using MySqlConnector;

namespace Project2
{
    public class DatosNave
    {
        public int IDNave;
        public string Nombre;
        public int Vida;
        public int Dano;
        public int Velocidad;
        public decimal Cadencia;
        public decimal Costo;
    }

    public class DatosAlien
    {
        public int IDAlienType;
        public string Nombre;
        public int Vida;
        public int Puntos;
    }

    public class DatosRanking
    {
        public int IDPlayer;
        public string Nombre;
        public int PuntajeAcumulado;
    }

    public class DatosNivel
    {
        public int IDNivel;
        public float MultiDano;
        public float MultiVel;
        public float MultiVida;
        public int PuntosNecesarios;
    }

    public static class BaseDatos
    {
        private static string conexion =
            "Server=localhost;Port=3306;Database=Alien_Invasion;User ID=root;Password=;";

        public static int ObtenerOCrearJugador(string nombre)
        {
            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                cn.Open();

                string consulta =
                    "select IDPlayer from Players where Nombre = @nombre";

                using (MySqlCommand cmd = new MySqlCommand(consulta, cn))
                {
                    cmd.Parameters.AddWithValue("@nombre", nombre);

                    object resultado = cmd.ExecuteScalar();

                    if (resultado != null)
                    {
                        return Convert.ToInt32(resultado);
                    }
                }

                string insertar =
                    "insert into Players (Nombre, Dinero, Edad) " +
                    "values (@nombre, 0, 0)";

                using (MySqlCommand cmd = new MySqlCommand(insertar, cn))
                {
                    cmd.Parameters.AddWithValue("@nombre", nombre);

                    cmd.ExecuteNonQuery();

                    return (int)cmd.LastInsertedId;
                }
            }
        }

        public static List<DatosNave> CargarNaves()
        {
            List<DatosNave> naves = new List<DatosNave>();

            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                cn.Open();

                string consulta =
                    "select IDNave, Nombre, Vida, Dano, Velocidad, Cadencia, Costo " +
                    "from Naves order by IDNave";

                using (MySqlCommand cmd = new MySqlCommand(consulta, cn))
                using (MySqlDataReader lector = cmd.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        DatosNave nave = new DatosNave();

                        nave.IDNave = lector.GetInt32("IDNave");
                        nave.Nombre = lector.GetString("Nombre");
                        nave.Vida = lector.GetInt32("Vida");
                        nave.Dano = lector.GetInt32("Dano");
                        nave.Velocidad = lector.GetInt32("Velocidad");
                        nave.Cadencia = lector.GetDecimal("Cadencia");
                        nave.Costo = lector.GetDecimal("Costo");

                        naves.Add(nave);
                    }
                }
            }

            return naves;
        }

        public static List<DatosNivel> CargarNiveles()
        {
            List<DatosNivel> niveles = new List<DatosNivel>();

            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                cn.Open();

                string consulta =
                    "select IDNivel, MultiDano, MultiVel, Multivida as MultiVida, PuntosNecesarios " +
                    "from Niveles order by IDNivel";

                using (MySqlCommand cmd = new MySqlCommand(consulta, cn))
                using (MySqlDataReader lector = cmd.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        DatosNivel nivel = new DatosNivel();

                        nivel.IDNivel = lector.GetInt32("IDNivel");
                        nivel.MultiDano = (float)lector.GetDecimal("MultiDano");
                        nivel.MultiVel = (float)lector.GetDecimal("MultiVel");
                        nivel.MultiVida = (float)lector.GetDecimal("MultiVida");
                        nivel.PuntosNecesarios = lector.GetInt32("PuntosNecesarios");

                        niveles.Add(nivel);
                    }
                }
            }

            return niveles;
        }

        public static int CrearSession(int idJugador)
        {
            using (MySqlConnection conexionBD = new MySqlConnection(conexion))
            {
                conexionBD.Open();

                string consulta = "insert into Sessions (FechaInicio, IDPlayer) " +
                                  "values (@fecha, @idJugador)";

                using (MySqlCommand comando = new MySqlCommand(consulta, conexionBD))
                {
                    comando.Parameters.AddWithValue("@fecha", DateTime.Now);
                    comando.Parameters.AddWithValue("@idJugador", idJugador);

                    comando.ExecuteNonQuery();

                    return Convert.ToInt32(comando.LastInsertedId);
                }
            }
        }

        // Cierra la sesion: fecha de fin y estado final (Victoria / Derrota)
        public static void FinalizarSession(int idSession, string estado)
        {
            using (MySqlConnection conexionBD = new MySqlConnection(conexion))
            {
                conexionBD.Open();

                string consulta = "update Sessions " +
                                  "set FechaFin = @fecha, EstadoFinal = @estado " +
                                  "where IDSession = @idSession";

                using (MySqlCommand comando = new MySqlCommand(consulta, conexionBD))
                {
                    comando.Parameters.AddWithValue("@fecha", DateTime.Now);
                    comando.Parameters.AddWithValue("@estado", estado);
                    comando.Parameters.AddWithValue("@idSession", idSession);

                    comando.ExecuteNonQuery();
                }
            }
        }

        // Guarda una fila en RegistrosNiveles por cada nivel jugado
        public static void GuardarRegistroNivel(
            int idSession,
            int idNivel,
            int puntaje,
            int enemigosEliminados,
            TimeSpan tiempo)
        {
            using (MySqlConnection conexionBD = new MySqlConnection(conexion))
            {
                conexionBD.Open();

                string consulta = "insert into RegistrosNiveles " +
                    "(TiempoInvertido, EnemigosEliminados, PuntajeTotal, IDSession, IDNivel) " +
                    "values (@tiempo, @enemigos, @puntaje, @idSession, @idNivel)";

                using (MySqlCommand comando = new MySqlCommand(consulta, conexionBD))
                {
                    comando.Parameters.AddWithValue("@tiempo", tiempo);
                    comando.Parameters.AddWithValue("@enemigos", enemigosEliminados);
                    comando.Parameters.AddWithValue("@puntaje", puntaje);
                    comando.Parameters.AddWithValue("@idSession", idSession);
                    comando.Parameters.AddWithValue("@idNivel", idNivel);

                    comando.ExecuteNonQuery();
                }
            }
        }

        public static void GuardarNaveElegida(int idJugador, int idNave)
        {
            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                cn.Open();

                string consulta =
                    "select count(*) from NavesPlayers " +
                    "where IDPlayer = @jugador and IDNave = @nave";

                using (MySqlCommand cmd = new MySqlCommand(consulta, cn))
                {
                    cmd.Parameters.AddWithValue("@jugador", idJugador);
                    cmd.Parameters.AddWithValue("@nave", idNave);

                    int existe = Convert.ToInt32(cmd.ExecuteScalar());

                    if (existe == 0)
                    {
                        string insertar =
                            "insert into NavesPlayers (IDPlayer, IDNave) " +
                            "values (@jugador, @nave)";

                        using (MySqlCommand cmdInsertar =
                            new MySqlCommand(insertar, cn))
                        {
                            cmdInsertar.Parameters.AddWithValue("@jugador", idJugador);
                            cmdInsertar.Parameters.AddWithValue("@nave", idNave);

                            cmdInsertar.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        public static List<DatosAlien> CargarTiposAliens()
        {
            List<DatosAlien> aliens = new List<DatosAlien>();

            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                cn.Open();

                string consulta =
                    "select IDAlienType, Nombre, Vida, PuntosOtorgados " +
                    "from AliensTypes order by IDAlienType";

                using (MySqlCommand cmd = new MySqlCommand(consulta, cn))
                using (MySqlDataReader lector = cmd.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        DatosAlien alien = new DatosAlien();

                        alien.IDAlienType = lector.GetInt32("IDAlienType");
                        alien.Nombre = lector.GetString("Nombre");
                        alien.Vida = lector.GetInt32("Vida");
                        alien.Puntos = lector.GetInt32("PuntosOtorgados");

                        aliens.Add(alien);
                    }
                }
            }

            return aliens;
        }

        public static List<DatosRanking> CargarRanking()
        {
            List<DatosRanking> jugadores = new List<DatosRanking>();

            using (MySqlConnection cn = new MySqlConnection(conexion))
            {
                cn.Open();

                string consulta =
                    "select p.IDPlayer, p.Nombre, " +
                    "sum(r.PuntajeTotal) as PuntajeAcumulado " +
                    "from Players p " +
                    "inner join Sessions s on p.IDPlayer = s.IDPlayer " +
                    "inner join RegistrosNiveles r on s.IDSession = r.IDSession " +
                    "group by p.IDPlayer, p.Nombre";

                using (MySqlCommand cmd = new MySqlCommand(consulta, cn))
                using (MySqlDataReader lector = cmd.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        DatosRanking jugador = new DatosRanking();

                        jugador.IDPlayer = lector.GetInt32("IDPlayer");
                        jugador.Nombre = lector.GetString("Nombre");
                        jugador.PuntajeAcumulado =
                            lector.GetInt32("PuntajeAcumulado");

                        jugadores.Add(jugador);
                    }
                }
            }

            return jugadores;
        }
    }
}
