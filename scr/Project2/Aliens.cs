using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Xna.Framework;

namespace Project2
{
    public struct AlienEnemigo
    {
        public Vector2 Posicion;
        public Rectangle Hitbox;
        public bool Activo;

        public AlienEnemigo(Vector2 posicionInicial, int ancho, int alto)
        {
            Posicion = posicionInicial;
            Hitbox = new Rectangle((int)posicionInicial.X, (int)posicionInicial.Y, ancho, alto);
            Activo = true;
        }
    }
}
