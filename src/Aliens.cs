
using Microsoft.Xna.Framework;

namespace Project2
{
    public struct AlienEnemigo
    {
        public Vector2 Posicion;
        public Rectangle Hitbox;
        public bool Activo;

        public int Vida;
        public int VidaMaxima;
        public int Puntos;
        public int IDAlienType;
        public string Nombre;

        public AlienEnemigo(Vector2 posicionInicial, int ancho, int alto, DatosAlien datos)
        {
            Posicion = posicionInicial;
            Hitbox = new Rectangle((int)posicionInicial.X, (int)posicionInicial.Y, ancho, alto);

            Activo = true;

            Vida = datos.Vida;
            VidaMaxima = datos.Vida;
            Puntos = datos.Puntos;
            IDAlienType = datos.IDAlienType;
            Nombre = datos.Nombre;
        }

        public bool RecibirDano(int dano)
        {
            Vida -= dano;

            if (Vida <= 0)
            {
                Vida = 0;
                Activo = false;
                return true;
            }

            return false;
        }
    }
}
