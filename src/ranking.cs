
using System.Collections.Generic;

namespace Project2
{
    public class Ranking
    {
        private List<DatosRanking> jugadores =
            new List<DatosRanking>();

        public int Cantidad
        {
            get { return jugadores.Count; }
        }

        public DatosRanking Obtener(int indice)
        {
            return jugadores[indice];
        }

        public void Cargar()
        {
            jugadores = BaseDatos.CargarRanking();
            Ordenar();
        }

        private void Ordenar()
        {
            for (int i = 0; i < jugadores.Count - 1; i++)
            {
                for (int j = 0; j < jugadores.Count - 1 - i; j++)
                {
                    if (jugadores[j].PuntajeAcumulado <
                        jugadores[j + 1].PuntajeAcumulado)
                    {
                        DatosRanking auxiliar = jugadores[j];

                        jugadores[j] = jugadores[j + 1];
                        jugadores[j + 1] = auxiliar;
                    }
                }
            }
        }
    }
}
