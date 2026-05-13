create database SalaKebrado;
-- drop database SalaKebrado
use SalaKebrado;

create table directores
(
 IDDirector int primary key auto_increment not null,
 nombre varchar(25),
 Edad int(2),
 Sueldo float
);
create table actores
(
 IDActor int primary key auto_increment not null,
 nombre varchar(25),
 Apellido varchar(25)
);
create table series
( 
 IDSerie int primary key auto_increment not null,
 nombre varchar(25),
 GeneroPrincipal varchar(25),
 AñoLanzamiento year,
 Presupuesto float,
 IDDirector int,
 foreign key (IDDirector) references directores(IDDirector)
);
create table plataformas
(
 IDPlataforma int primary key auto_increment not null,
 nombre varchar(25),
 AñoLanzamiento year
);
create table series_plataformas
(
 IDSerie_Plataforma int primary key auto_increment not null,
 IDPlataforma int,
 foreign key (IDPlataforma) references plataformas(IDPlataforma),
 IDSerie int,
 foreign key (IDSerie) references series(IDSerie)
);
create table personajes
(
 IDPersonajes int primary key auto_increment not null,
 Nombre varchar(25),
 edad int(3), 
 Genero enum("M", "F"),
 IDActor int,
 foreign key (IDActor) references actor(IDActor)
);
create table temporadas
(
 IDTemporada int primary key auto_increment not null,
 NumTemp int(2),
 Nombre varchar(25),
 descripcion text, 
 Genero enum("M", "F"),
 IDSerie int,
 foreign key (IDSerie) references series(IDSerie)
);
create table episodios
(
 IDEpisodos int primary key auto_increment not null,
 NumEp int(2),
 Nombre varchar(25),
 descripcion text, 
 puntuacion enum("0","1","2","3","4","5","6","7","8","9","10"),
 IDTemporada int,
 foreign key (IDTemporada) references temporadas(IDTemporada)
);
create table episodios_personajes
(
 IDEpisodio_Personaje int primary key auto_increment not null,
 IDPersonaje int,
 foreign key (IDPersonaje) references personajes(IDPersonaje),
 IDSerie int,
 foreign key (IDSerie) references series(IDSerie)
);
