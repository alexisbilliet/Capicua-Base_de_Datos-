create database FutbolLocal;
use FutbolLocal;
-- drop database FutbolLocal
create table equipos (
	IDEquipo int primary key auto_increment not null,
    nombre varchar(25),
    Fundacion date
);
create table estadios (
	IDEstadio int primary key auto_increment not null,
    nombre varchar(25),
    ubicacion varchar(25)
);
create table jugadores (
	IDJugadores int primary key auto_increment not null,
    nombre varchar(25),
    posicion Varchar(25),
    IDEquipo int,
    foreign key(IDEquipo) references equipos(IDEquipo)
);
create table partidos (
	IDPartido int primary key auto_increment not null,
    Fecha date,
    golesequipo1 int(2),
    golesequipo2 int(2),
    IDEquipo1 int,
    foreign key(IDEquipo1) references equipos(IDEquipo),
    IDEquipo2 int,
    foreign key(IDEquipo2) references equipos(IDEquipo),
    IDEstadio int,
    foreign key(IDEstadio) references estadios(IDEstadio)
);

insert into equipos (nombre, fundacion) values 
('club atlético caseros', '1920-05-01'),
('san martín fc', '1945-03-15');

insert into estadios (nombre, ubicacion) values
('estadio  caseros', 'caseros'),
('estadio san martín', 'san martín');

insert into jugadores (nombre, posicion, IDEquipo) values 
('juan pérez', 'arquero', 1),
('carlos gómez', 'defensor', 2);

insert into partidos (fecha, golesequipo1, golesequipo2, idequipo1, IDEquipo2, IDEstadio)values 
('2026-05-01', 2, 1, 1, 2, 1),
('2026-05-02', 3, 3, 2, 1, 2);

select partidos.fecha, partidos.golesequipo1, partidos.golesequipo2, equipos1.nombre, equipos2.nombre
from partidos, equipos equipos1, equipos equipos2
where partidos.IDEquipo1 = equipos1.IDEquipo and partidos.IDEquipo2 = equipos2.IDEquipo;



select nombre, posicion
from jugadores