create database Serie;
-- drop database Serie
use Serie;

create table Creadores
(
	IDCreador int not null auto_increment primary key,
    Nombre varchar(25),
    Apellido varchar(25),
    Edad int
);
create table Series
(
	IDSerie int not null auto_increment primary key,
    Nombre varchar(25),
    Estreno year,
    IDCreador int,
    foreign key (IDCreador) references Creadores(IDCreador)
);
create table Personajes
(
	IDPersonaje int not null auto_increment primary key,
    Nombre varchar(25),
    IDSerie int,
    foreign key(IDSerie) references Series(IDSerie),
    Rol Varchar(25),
	NivelEnergia int
);
create table Episodios
(
	IDEpisodio int not null auto_increment primary key,
    Titulo varchar(25),
    IDSerie int,
    foreign key(IDSerie) references Series(IDSerie),
	DuracionMinutos int,
    Rating float
);
create table HabilidadesEspeciales
(
	IDHabilidad int not null auto_increment primary key,
    Nombre Varchar(25),
	Tipo Varchar(25)
);
create table HabilidadesPersonajes
(
	IDHabilidadPersonaje int not null auto_increment primary key,
    IDPersonaje int,
    foreign key (IDPersonaje) references Personajes(IDPersonaje),
    IDHabilidad int,
    foreign key (IDHabilidad) references HabilidadesEspeciales(IDHabilidad)
);
create table Rivalidades
(
	IDRivalidad int not null auto_increment primary key,
    IDHeroe int,
    foreign key(IDHeroe) references Personajes(IDPersonaje),
    IDVillano int,
    foreign key(IDVillano) references Personajes(IDPersonaje),
    Encuentros int
);
create table ObjetosMisticos
(
	IDObjeto int not null auto_increment primary key,
    Nombre varchar(25),
    IDPersonajeDuenio int,
    foreign key(IDPersonajeDuenio) references Personajes(IDPersonaje),
    ValorSubasta int
);

insert into Creadores(Nombre, Apellido, edad) values
("Quentin", "Tarantino", 63),
("Martin", "Scorsese", 73),
("Christopher", "Nolan", 73);

insert into Series(Nombre, Estreno, IDCreador) values
("Hora De Aventura", 2016, 1),
("Ben 10", 2005, 1),
("Billy y Mandy", 2003, 2),
("Un Show Mas", 2010, 2),
("Coraje el Perro Cobarde", 1999, 3),
("El laboratorio de Dexter", 1996, 3);

insert into Personajes(Nombre, IDSerie, Rol, NivelEnergia) values
("Finn El Humano", 1, "Protagonista", 85),
("Jake el Perro", 1, "Protagonista", 90),
("Rey Helado", 1, "Antagonista", 75),
("Ben Tennyson", 2, "Protagonista", 95),
("Vilgax", 2, "Antagonista", 98),
("Puro Hueso", 3, "Secundario", 80),
("Mordecai", 4, "Protagonista", 60),
("Rigby", 4, "Protagonista", 55),
("Coraje", 5, "Protagonista", 40),
("Dexter", 6, "Protagonista", 70);

insert into Episodios(Titulo, IDSerie, DuracionMinutos, Rating) values
("Rescate de Jake", 1, 40, 8.7),
("El Omnitrix", 2, 22, 6.9),
("El problema de Billy", 3, 27, 4.9),
("El regreso del diablo", 4, 32, 9.4),
("Cobardia", 5, 21, 7.1),
("La explosion", 6, 34, 8.1);

insert into HabilidadesEspeciales(Nombre, Tipo) values
("Uso de la Espada", "Cuerpo a Cuerpo"),
("Elongacion", "Apoyo"),
("Hielo", "Ataque a distancia"),
("Convertirse", "Transformacion"),
("Proyeccion de Energio", "Ataque a distancia"),
("Telequinesis", "Ataque a distancia"),
("Artes Marciales", "Cuerpo a Cuerpo"),
("agujeros negros", "Creacion"),
("Valentia", "Apoyo"),
("Superdotado", "Apoyo");

insert into HabilidadesPersonajes(IDPersonaje, IDHabilidad) values
(1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10);

insert into Rivalidades(IDHeroe, IDVillano, Encuentros) values
(1,3,25), (2,3,20), (4,5,35), (7,6,12), (8,6,10), (9,3,8), (10,5,15);

insert into ObjetosMisticos(Nombre, IDPersonajeDuenio, ValorSubasta) values
("Espada de Diamante", 1, 1000000),
("BMO", 2, 50000),
("Corona Magica", 3, 800000),
("Omnitrix", 4, 9999999),
("Ascalon", 5, 100000),
("Hueso de Percebe", 6, 100000000),
("El Poder", 7, 250000),
("Guantes de la Suerte", 8, 200000),
("Hueso", 9, 4000),
("Mochila Voladora", 10, 9999999);


select Series.nombre as NombreSerie, Creadores.Nombre as NombreCreador
from Series
inner join Creadores
on Series.IDCreador = Creadores.IDCreador
order by Series.nombre asc;


select Nombre, Rol
from personajes
where Nombre like "B%" or Nombre like "F%";


select Titulo, DuracionMinutos, Rating
from Episodios
where rating > 8.5 and DuracionMinutos > 11;


select Nombre
from ObjetosMisticos
where nombre like "%Espada%" or nombre like "%Anillo%";


select MAX(NivelEnergia) as EnergiaMaxima, MIN(NivelEnergia) as EnergiaMinima
from personajes
where Rol = "Antagonista";

select Tipo, Count(IDHabilidad)
from HabilidadesEspeciales
group by Tipo;

select nombre, NivelEnergia
from personajes
order by NivelEnergia desc;


select IDPersonajeduenio, SUM(ValorSubasta) as ValorTotal
from ObjetosMisticos
where ValorSubasta > 5000
group by IDPersonajeDuenio
order by ValorTotal desc;


select IDSerie, AVG(Rating) as PromedioRating
from Episodios
group by IDSerie
having PromedioRating > 7.5;


select IDSerie, count(IDPersonaje)
from Personajes
where NivelEnergia > 50
group by IDSerie;



select Series.nombre, AVG(DuracionMinutos) as PromedioDuracionEpisodios
from Series
inner join Episodios
on Episodios.IDSerie = Series.IDSerie
where Series.Estreno > 2010
group by Series.IDSerie;



select Personajes.IDPersonaje, Personajes.Nombre, COUNT(HabilidadesEspeciales.IDHabilidad) as TotalHabilidades
from HabilidadesEspeciales
inner join HabilidadesPersonajes
on HabilidadesEspeciales.IDHabilidad = HabilidadesPersonajes.IDHabilidad
inner join Personajes
on HabilidadesPersonajes.IDPersonaje = Personajes.IDPersonaje
group by Personajes.IDPersonaje
having TotalHabilidades > 3;


select Rivalidades.IDRivalidad, Rivalidades.Encuentros
from Rivalidades
where Rivalidades.Encuentros > 15
order by Rivalidades.Encuentros desc;



select IDPersonajeduenio, IDObjeto, nombre as ArtefactoMasCaro, MAX(ValorSubasta) as Valor 
from ObjetosMisticos
group by IDPersonajeduenio
having Valor > 100000;



select IDSerie, COUNT(IDEpisodio) as TotalEpisodios
from Episodios
group by IDSerie
order by TotalEpisodios desc
