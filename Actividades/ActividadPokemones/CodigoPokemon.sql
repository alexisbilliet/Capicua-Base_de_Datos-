Create database Pokemon;
-- DROP DATABASE Pokemon
use Pokemon;

Create table Regiones
(
	IDRegion int primary key not null auto_increment,
    Nombre varchar(25),
    Clima varchar(25)
);
Create table Ciudades
(
	IDCiudad int primary key not null auto_increment,
    Nombre varchar(25),
    Poblacion int, 
    IDRegion int,
    foreign key (IDRegion) references Regiones(IDRegion)
);
Create table Entrenadores
(
	IDEntrenador int primary key not null auto_increment,
    Nombre varchar(25),
    Edad int, 
    IDCiudad int,
    foreign key (IDCiudad) references Ciudades(IDCiudad)
);
Create table Especies
(
	IDEspecie int primary key not null auto_increment,
    Nombre varchar(25),
    NumPokeDex int, 
    TipoElemento varchar(25),
    IDRegion int,
    foreign key (IDRegion) references Regiones(IDRegion)
);
Create table Pokemones
(
	IDPokemon int primary key not null auto_increment,
    Nombre varchar(25),
    Nivel int,
    IDEntrenador int,
    foreign key (IDEntrenador) references Entrenadores(IDEntrenador),
    IDEspecie int,
    foreign key (IDEspecie) references Especies(IDEspecie)
);
Create table Evoluciones
(
	IDEvolucion int primary key not null auto_increment,
    IDFaseNueva int,
    foreign key (IDFaseNueva) references Especies(IDEspecie),
    IDFasePrevia int,
    foreign key (IDFasePrevia) references Especies(IDEspecie)
);
Create table HistorialEvoluciones
(
	IDHistorial int primary key not null auto_increment,
    Fecha date, 
    MetodoEvolucion text,
    IDPokemon int,
    foreign key (IDPokemon) references Pokemones(IDPokemon),
    IDEvolucion int,
    foreign key (IDEvolucion) references Evoluciones(IDEvolucion)
);
Create table Gimnasios
(
	IDGimnasio int primary key not null auto_increment,
    Nombre Varchar(50), 
    TipoElemento varchar(25),
    IDLider int,
    foreign key (IDLider) references Entrenadores(IDEntrenador),
    IDCiudad int,
    foreign key (IDCiudad) references Ciudades(IDCiudad)
);
Create table Objetos
(
	IDObjeto int primary key not null auto_increment,
    Nombre varchar(25),
    descripcion text
);
Create table Equipos
(
	IDRegistro int primary key not null auto_increment,
    IDEntrenador int,
    foreign key (IDEntrenador) references Entrenadores(IDEntrenador),
    IDPokemon int,
    foreign key (IDPokemon) references Pokemones(IDPokemon),
    IDObjeto int, 
    foreign key (IDObjeto) references Objetos(IDObjeto)
);
Create table Batallas
(
	IDBatalla int primary key not null auto_increment,
    Fecha date, 
    Ganador enum("Atacante", "Defensor"),
    IDAtacante int,
    foreign key (IDAtacante) references Entrenadores(IDEntrenador),
    IDDefensor int,
    foreign key (IDDefensor) references Entrenadores(IDEntrenador)
);
Create table BatallasGimnasios
(
	IDBatallaGimnasio int primary key not null auto_increment,
    IDBatalla int,
    foreign key (IDBatalla) references Batallas(IDBatalla),
    IDGimnasio int,
    foreign key (IDGimnasio) references Gimnasios(IDGimnasio)
);


insert into Regiones(Nombre, Clima) values
( "Kanto", "Templado"),
("Johto", "Humedo");

insert into Ciudades(Nombre, Poblacion, IDRegion) values
("Isla Canela", 50, 1),
("Ciudad Malva", 200, 2);

insert into Entrenadores(Nombre, Edad, IDCIudad) values
("Red", 10, 1),
("Gold", 11, 2),
("Blaine", 58, 1),
("Pegaso", 20, 2);

insert into Especies(Nombre, NumPokeDex, TipoElemento, IDRegion) values
("Bulbasaur", 1, "Planta-Veneno", 1),
("Ivysaur", 2, "Planta-Veneno", 1),
("Pichu", 172, "Electrico", 2),
("Mewtwo", 150, "Psiquico", 1),
("Magmar", 126, "Fuego", 1),
("Pidgey", 16, "Volador-Normal", 2);

insert into Pokemones(Nombre, Nivel, IDEntrenador, IDEspecie) values
("Ranota", 27, 1, 2),
("Rata", 8, 2, 3),
("DiosTodoPoderoso", 99, 1, 4),
("Inferno", 23, 3, 5),
("Reinger", 6, 4, 6);


insert into Evoluciones(IDFaseNueva, IDFasePrevia) values
(2, 1);


insert into HistorialEvoluciones(Fecha, MetodoEvolucion, IDPokemon, IDEvolucion) values
("2026-08-03", "Nivel", 2, 1);

insert into Gimnasios(Nombre, TipoElemento, IDLider, IDCiudad) values
("Gimnasio de Isla Canela", "Fuego", 3, 1),
("Gimnasio de Ciudad Malva", "Volador", 4, 2);

insert into Objetos(Nombre, Descripcion) values
("Restos", "Cura 1/16 de los Puntos de Salud (PS) totales del Pokémon que lo lleva equipado al final de cada turno."),
("Piedra Eterna", "impide que el Pokémon que la lleva equipada evolucione.");

insert into Equipos(IDEntrenador, IDPokemon, IDObjeto) values
(1, 1, 1), (1, 3, null), (2, 2, 2), (3, 4, null), (4, 5, 1);

insert into Batallas(Fecha, Ganador, IDAtacante, IDDefensor) values
("2026-09-14", "Atacante", 1, 2),
("2026-09-16", "Defensor", 4, 3),
("2026-09-19", "Atacante", 2, 4),
("2026-09-20", "Defensor", 2, 3);

insert into BatallasGimnasios(IDBatalla, IDGimnasio) values
(3, 2), (4, 1);



select e.nombre, e.edad, c.nombre as ciudad
from entrenadores e
inner join ciudades c on e.IDCiudad = c.IDCiudad;


select nombre, tipoelemento
from especies;

select p.nombre, p.Nivel, e.Nombre as Especie
from pokemones p
inner join especies e on e.IDEspecie = p.IDEspecie
where p.nivel > 50;

select p.nombre, p.Nivel, e.Nombre as Especie, en.nombre
from pokemones p
inner join entrenadores en on en.IDEntrenador = p.IDEntrenador 
inner join especies e on e.IDEspecie = p.IDEspecie
where e.tipoelemento like "%fuego%"
order by p.nivel desc;


select p.nombre as Pokemon, entrenadores.nombre as entrenador, ciudades.nombre as ciudad
from pokemones p
inner join entrenadores on entrenadores.IDEntrenador = p.IDEntrenador
inner join ciudades on ciudades.IDCiudad = entrenadores.IDCiudad
where p.IDEntrenador in (select IDEntrenador from entrenadores inner join ciudades on ciudades.IDCiudad = entrenadores.IDCiudad where ciudades.nombre = "Ciudad Malva");

select nombre, nivel
from pokemones
where nivel > (select avg(nivel) from pokemones);


select Nombre
from Pokemones
where IDEntrenador in (select IDAtacante from Batallas where Ganador = "Atacante") or IDEntrenador in ( select IDDefensor from Batallas where Ganador = "Defensor" );

DELIMITER //
CREATE PROCEDURE SubirDeNivel(
IN NombreE Varchar(50)
)
BEGIN
update pokemones set nivel = nivel + 1 where IDEntrenador = (select IDEntrenador from entrenadores where nombre = NombreE);
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE RegistrarBatalla(
in fecha date,
in ganador enum("atacante", "defensor"),
IN Atacante Varchar(50),
IN Defensor Varchar(50)
)
BEGIN
insert into batallas(fecha, ganador, IDAtacante, IDDefensor) values
(fecha, ganador, (select IDEntrenador from entrenadores where nombre=Atacante),(select IDEntrenador from entrenadores where nombre=Defensor) );
END //
DELIMITER ;
